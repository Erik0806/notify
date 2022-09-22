import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/controllers/archieve_notifies_controller.dart';
import 'notify_card.dart';

class ArchieveNotifies extends StatelessWidget {
  const ArchieveNotifies({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArchieveNotifiesController>(
      init: ArchieveNotifiesController(),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemBuilder: (context, id) {
              return NotifyCard(
                notify: _.archieveNotifies[id],
                onTextChanged: ((value) {
                  _.changeNotifyText(_.archieveNotifies[id].id, value);
                }),
                onDeleteCalled: () {
                  _.deleteNotify(_.archieveNotifies[id].id);
                },
              );
            },
            itemCount: _.archieveNotifies.length,
          ),
        );
      },
    );
  }
}
