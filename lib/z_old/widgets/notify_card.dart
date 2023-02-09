import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notify/z_old/widgets/neumorphic_card.dart';

import '../controllers/active_notifies_controller.dart';
import '../controllers/archieve_notifies_controller.dart';
import '../controllers/controller.dart';
import '../models/notify.dart';
import 'neumorphic_button.dart';

class NotifyCard extends StatefulWidget {
  const NotifyCard(
      {super.key,
      required this.notify,
      this.onTextChanged,
      this.onDeleteCalled});

  final Notify notify;
  final ValueChanged<String>? onTextChanged;
  final Callback? onDeleteCalled;

  @override
  State<NotifyCard> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<NotifyCard> {
  TextEditingController textEditingController = TextEditingController();
  bool compact = true;
  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.notify.text;
    if (widget.notify.firstTimeOpen) {
      compact = false;
    }
    return NeumorphicCard(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      handleDateTimeTap();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: compact
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            compact ? Text(getDateString()) : Container(),
                            Text(
                              '${widget.notify.fireTime.hour.toString().length == 1 ? '0${widget.notify.fireTime.hour}' : widget.notify.fireTime.hour}:${widget.notify.fireTime.minute.toString().length == 1 ? '0${widget.notify.fireTime.minute}' : widget.notify.fireTime.minute}',
                              style: Theme.of(context).textTheme.headline1,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        compact
                            ? widget.notify.text != ""
                                ? Text(
                                    widget.notify.text,
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                : const SizedBox()
                            : Text(
                                '${widget.notify.fireTime.day.toString().length == 1 ? '0${widget.notify.fireTime.day}' : widget.notify.fireTime.day}.${widget.notify.fireTime.month.toString().length == 1 ? '0${widget.notify.fireTime.month}' : widget.notify.fireTime.month}.${widget.notify.fireTime.year}',
                              ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    compact
                        ? Container()
                        : NeumorphicButton(
                            margin: 8,
                            icon: const Icon(Icons.delete_forever_outlined),
                            inset: true,
                            onTap: () {
                              compact = true;
                              widget.onDeleteCalled!();
                            },
                          ),
                    NeumorphicButton(
                      margin: 8,
                      icon: Icon(
                        compact ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                      ),
                      inset: true,
                      onTap: () {
                        setState(() {
                          compact = !compact;
                        });
                        widget.notify.firstTimeOpen = false;
                      },
                    ),
                  ],
                ),
              ],
            ),
            compact
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      minLines: 2,
                      maxLines: 7,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                      ),
                      autofocus: widget.notify.firstTimeOpen,
                      controller: textEditingController,
                      onChanged: (value) {
                        widget.notify.firstTimeOpen = false;
                        if (widget.onTextChanged != null) {
                          widget.onTextChanged!(value);
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String getDateString() {
    DateTime fireTime = widget.notify.fireTime;
    DateTime now = DateTime.now();
    int difference2 = fireTime
        .subtract(Duration(hours: fireTime.hour, minutes: fireTime.minute))
        .difference(
            now.subtract(Duration(hours: now.hour, minutes: now.minute)))
        .inDays;
    //int difference = fireTime.difference(now).inDays;
    if (difference2.abs() <= 6) {
      int fireDay = fireTime.day;
      int today = now.day;

      if (fireDay == today) {
        return 'Heute';
      } else if (fireDay - today == 1 ||
          (difference2 == 0 && fireTime.month > now.month)) {
        return 'Morgen';
      } else if (fireDay > today || fireTime.month > now.month) {
        return 'Nächsten ${DateFormat('EEEEEEEEE').format(widget.notify.fireTime)}';
      } else {
        return 'Letzten ${DateFormat('EEEEEEEEE').format(widget.notify.fireTime)}';
      }
    }
    return DateFormat('EE dd.MM.', 'de_DE').format(widget.notify.fireTime);
  }

  handleDateTimeTap() async {
    if (compact) {
      setState(() {
        compact = false;
        widget.notify.firstTimeOpen = false;
      });
    } else {
      widget.notify.firstTimeOpen = false;
      //Material Date Picker
      if (Get.find<Controller>().sharedPreferences.getBool('material') ??
          true) {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: widget.notify.fireTime,
          firstDate: widget.notify.fireTime.isBefore(DateTime.now())
              ? widget.notify.fireTime
              : DateTime.now(),
          lastDate: DateTime(2100),
        );
        TimeOfDay? time;
        if (date != null) {
          time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(widget.notify.fireTime),
          );
        }
        if (date != null && time != null) {
          compact = true;
          DateTime newDate =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (Get.isRegistered<ActiveNotifiesController>()) {
            Get.find<ActiveNotifiesController>()
                .changeNotifyTime(widget.notify.id, newDate);
          } else if (Get.isRegistered<ArchieveNotifiesController>()) {
            Get.find<ArchieveNotifiesController>()
                .changeNotifyTime(widget.notify.id, newDate);
          }
        }
        //Cupertino DatePicker
      } else {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          // minTime: DateTime.now().subtract(days(10)),

          minTime: widget.notify.fireTime.isBefore(DateTime.now())
              ? widget.notify.fireTime
              : DateTime.now().add(minutes(2)),
          maxTime: DateTime(2100, 0, 0),
          onConfirm: (date) {
            compact = true;
            if (Get.isRegistered<ActiveNotifiesController>()) {
              Get.find<ActiveNotifiesController>()
                  .changeNotifyTime(widget.notify.id, date);
            } else if (Get.isRegistered<ArchieveNotifiesController>()) {
              Get.find<ArchieveNotifiesController>()
                  .changeNotifyTime(widget.notify.id, date);
            }
          },
          currentTime: widget.notify.fireTime,
          locale: LocaleType.de,
        );
      }
    }
  }
}
