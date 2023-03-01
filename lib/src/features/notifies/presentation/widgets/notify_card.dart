import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/features/notifies/data/notify_repository.dart';
import 'package:notify/src/features/notifies/domain/notify.dart';
import 'package:notify/src/features/notifies/presentation/notifies_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/utils/logger.dart';

class NotifyCard extends HookConsumerWidget {
  const NotifyCard({
    super.key,
    required this.stateNotifierProvider,
  });

  final StateNotifierProvider stateNotifierProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index = ref.read(currentNotifyIndexProvider);

    final Notify? intNotify = ref.watch(
      stateNotifierProvider.select(
        (value) {
          if (value.length <= index) {
            return null;
          } else {
            return value[index];
          }
        },
      ),
    );
    if (intNotify == null) {
      return const SizedBox(
        height: 0,
      );
    }
    final expanded = ref
        .watch(notifyExpandedProvider.select((value) => value == intNotify.id));
    ref.read(loggerProvider).i('Built notifyCard');

    return GestureDetector(
      onTap: () {
        if (expanded) {
          ref.read(notifyExpandedProvider.notifier).state = 0;
        } else {
          ref.read(notifyExpandedProvider.notifier).state = intNotify.id;
        }
      },
      child: Slidable(
        closeOnScroll: true,
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          // extentRatio: 0.5,
          children: [
            const SizedBox(
              width: 4,
            ),
            GestureDetector(
              onTap: () {
                ref.read(notifyRepositoryProvider.notifier).changeNotify(
                      intNotify.id,
                      intNotify.text,
                      intNotify.fireTime.subtract(1.hours),
                      true,
                    );
              },
              child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 1.2,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  child: const Icon(Icons.remove)),
            ),
            GestureDetector(
              onTap: () {
                ref.read(notifyRepositoryProvider.notifier).changeNotify(
                      intNotify.id,
                      intNotify.text,
                      intNotify.fireTime.add(1.hours),
                      true,
                    );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 1.2,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(notifyRepositoryProvider.notifier).changeNotify(
                      intNotify.id,
                      intNotify.text,
                      intNotify.fireTime.add(1.days),
                      true,
                    );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    width: 1.2,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                child: const Icon(Icons.double_arrow),
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.0000001,
          dismissible: DismissiblePane(
            onDismissed: () {
              ref
                  .read(notifyRepositoryProvider.notifier)
                  .deleteNotify(intNotify.id);
            },
          ),
          children: const [],
        ),
        key: UniqueKey(),
        child: Container(
          margin: const EdgeInsets.all(4),
          // duration: const Duration(seconds: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.2,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: expanded
                ? ExpandedNotifyCard(
                    notify: intNotify,
                    dateText: NotifyController.getNotifyDateText(
                      intNotify.fireTime,
                      dateFormat: true,
                    ),
                    timeText: NotifyController.getNotifyTimeText(
                      intNotify.fireTime,
                    ),
                    onDeleteTap: (BuildContext newContext) {
                      Slidable.of(newContext)?.dismiss(
                        ResizeRequest(
                          const Duration(milliseconds: 300),
                          () {
                            ref
                                .read(notifyRepositoryProvider.notifier)
                                .deleteNotify(intNotify.id);
                          },
                        ),
                      );
                    },
                    onDoneTap: (newFireTime, newText) {
                      ref.read(notifyRepositoryProvider.notifier).changeNotify(
                          intNotify.id, newText, intNotify.fireTime);
                      ref.read(notifyExpandedProvider.notifier).state = 0;
                    },
                  )
                : CollapsedNotifyCard(
                    notify: intNotify,
                    dateText: NotifyController.getNotifyDateText(
                      intNotify.fireTime,
                    ),
                    timeText: NotifyController.getNotifyTimeText(
                      intNotify.fireTime,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class CollapsedNotifyCard extends StatelessWidget {
  const CollapsedNotifyCard({
    super.key,
    required this.notify,
    required this.dateText,
    required this.timeText,
  });

  final Notify notify;
  final String dateText;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeText,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              notify.id.toString(),
              // dateText, TODO change back
              textAlign: TextAlign.start,
            ),
          ],
        ),
        const SizedBox(width: 40),
        Expanded(
          child: Text(
            notify.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

class ExpandedNotifyCard extends HookConsumerWidget {
  const ExpandedNotifyCard({
    super.key,
    required this.notify,
    required this.timeText,
    required this.dateText,
    required this.onDoneTap,
    required this.onDeleteTap,
  });
  final Notify notify;
  final String timeText;
  final String dateText;
  final Function(DateTime newFireTime, String newText) onDoneTap;
  final Function(BuildContext context) onDeleteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(
      text: notify.text,
    );
    var notifyTime = notify.fireTime;
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: notifyTime,
              firstDate: DateTime(1900),
              lastDate: DateTime(3000),
            );
            if (date != null) {
              // ignore: use_build_context_synchronously
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(notifyTime),
              );

              if (time != null) {
                DateTime newDate = DateTime(
                    date.year, date.month, date.day, time.hour, time.minute);
                ref
                    .read(notifyRepositoryProvider.notifier)
                    .changeNotify(notify.id, textController.text, newDate);
              }
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              GestureDetector(
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(notifyTime),
                  );

                  if (time != null) {
                    DateTime newDate = DateTime(
                        notify.fireTime.year,
                        notify.fireTime.month,
                        notify.fireTime.day,
                        time.hour,
                        time.minute);
                    ref
                        .read(notifyRepositoryProvider.notifier)
                        .changeNotify(notify.id, textController.text, newDate);
                  }
                },
                child: Text(
                  timeText,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontSize: 58),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                dateText,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(),
              top: BorderSide(),
            ),
          ),
          padding: const EdgeInsets.only(left: 4),
          child: TextField(
            maxLines: null,
            autofocus: notify.firstTimeOpen,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.description,
              filled: false,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            controller: textController,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                onDeleteTap(context);
              },
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                onDoneTap(notify.fireTime, textController.text);
              },
              child: Text(
                AppLocalizations.of(context)!.done,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        )
      ],
    );
  }
}
