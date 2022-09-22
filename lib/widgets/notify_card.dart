import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:notify/controllers/active_notifies_controller.dart';
import 'package:notify/controllers/archieve_notifies_controller.dart';
import 'package:notify/widgets/neumorphic_button.dart';
import 'package:notify/widgets/neumorphic_card.dart';

import '../models/notify.dart';

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
              children: [
                GestureDetector(
                  onTap: () {
                    handleDateTimeTap();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.notify.fireTime.hour.toString().length == 1 ? '0${widget.notify.fireTime.hour}' : widget.notify.fireTime.hour}:${widget.notify.fireTime.minute.toString().length == 1 ? '0${widget.notify.fireTime.minute}' : widget.notify.fireTime.minute}',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      compact
                          ? Text(widget.notify.text)
                          : Text(
                              '${widget.notify.fireTime.day.toString().length == 1 ? '0${widget.notify.fireTime.day}' : widget.notify.fireTime.day}.${widget.notify.fireTime.month.toString().length == 1 ? '0${widget.notify.fireTime.month}' : widget.notify.fireTime.month}.${widget.notify.fireTime.year}',
                            ),
                    ],
                  ),
                ),
                const Spacer(),
                NeumorphicButton(
                  margin: 8,
                  icon: Icon(
                    compact ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                    color: Theme.of(context).colorScheme.secondary,
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
            compact
                ? Container()
                : NeumorphicButton(
                    margin: 8,
                    icon: const Icon(Icons.delete_forever_outlined),
                    inset: true,
                    onTap: () {
                      widget.onDeleteCalled!();
                    },
                  ),
          ],
        ),
      ),
    );
  }

  handleDateTimeTap() {
    if (compact) {
      setState(() {
        compact = false;
      });
      widget.notify.firstTimeOpen = false;
    } else {
      widget.notify.firstTimeOpen = false;
      if (Get.isRegistered<ActiveNotifiesController>()) {
        Get.find<ActiveNotifiesController>().update();
      } else if (Get.isRegistered<ArchieveNotifiesController>()) {
        Get.find<ArchieveNotifiesController>().update();
      }
      DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        minTime: DateTime.now().add(const Duration(minutes: 2)),
        maxTime: DateTime(2100, 0, 0),
        onConfirm: (date) {
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
