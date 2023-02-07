import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notify/old/controllers/active_notifies_controller.dart';
import 'package:notify/old/widgets/neumorphic_button.dart';
import 'package:notify/old/widgets/neumorphic_card.dart';
import 'package:notify/old/widgets/notify_card.dart';

class ActiveNotifies extends StatelessWidget {
  const ActiveNotifies({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ActiveNotifiesController(),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemBuilder: (context, id) {
              if (id != 0) {
                return NotifyCard(
                  notify: _.activeNotifies[id - 1],
                  onTextChanged: ((value) {
                    _.changeNotifyText(_.activeNotifies[id - 1].id, value);
                  }),
                  onDeleteCalled: () {
                    _.deleteNotify(_.activeNotifies[id - 1].id);
                  },
                );
              } else {
                return NeumorphicCard(
                  child: NeumorphicButton(
                    icon: const Icon(Icons.add),
                    inset: true,
                    onTap: () {
                      _.addNotify();
                    },
                  ),
                );
              }
            },
            itemCount: _.activeNotifies.length + 1,
          ),
        );
      },
    );
  }
}
