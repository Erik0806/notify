import 'package:get/get.dart';
import 'package:notify/z_old/controllers/controller.dart';

import '../models/notify.dart';

class ArchieveNotifiesController extends GetxController {
  List<Notify> archieveNotifies = [];

  ArchieveNotifiesController() {
    getNotifies();
  }

  void getNotifies() {
    DateTime now = DateTime.now();
    archieveNotifies.clear();
    List<Notify> notifies = Get.find<Controller>().notifies;
    List<Notify> toDelete = [];
    for (var notify in notifies) {
      if (notify.fireTime.isBefore(now)) {
        if (notify.fireTime.isBefore(DateTime.now()
                .subtract(Get.find<Controller>().notizenLoeschenNach)) &&
            Get.find<Controller>().notizenLoeschenNach != const Duration()) {
          toDelete.add(notify);
        } else {
          archieveNotifies.add(notify);
        }
      }
    }
    archieveNotifies.sort(
      (a, b) => b.compareTo(a),
    );
    for (var notify in toDelete) {
      notifies.remove(notify);
    }
    update();
  }

  void changeNotifyText(int id, String text) {
    List<Notify> notifies = Get.find<Controller>().notifies;
    int place = -1;
    for (var i = 0; i < notifies.length; i++) {
      if (notifies[i].id == id) {
        place = i;
      }
    }
    if (place != -1) {
      Get.find<Controller>().notifies[place].text = text;
    }
    place = -1;
    for (var i = 0; i < archieveNotifies.length; i++) {
      if (archieveNotifies[i].id == id) {
        place = i;
      }
    }
    if (place != -1) {
      archieveNotifies[place].text = text;
      Notify notify = archieveNotifies[place];
      Get.find<Controller>().changeNotification(notify);
    }
    Get.find<Controller>().safeAll();
  }

  void changeNotifyTime(int id, DateTime fireTime) {
    List<Notify> notifies = Get.find<Controller>().notifies;
    int place = -1;
    for (var i = 0; i < notifies.length; i++) {
      if (notifies[i].id == id) {
        place = i;
      }
    }
    if (place != -1) {
      Get.find<Controller>().notifies[place].fireTime = fireTime;
    }
    place = -1;
    for (var i = 0; i < archieveNotifies.length; i++) {
      if (archieveNotifies[i].id == id) {
        place = i;
      }
    }
    if (place != -1) {
      archieveNotifies[place].fireTime = fireTime;
      Notify notify = archieveNotifies[place];
      Get.find<Controller>().changeNotification(notify);
    }
    archieveNotifies.sort(
      (a, b) => b.compareTo(a),
    );
    Get.find<Controller>().safeAll();
    update();
  }

  void deleteNotify(int id) {
    Get.find<Controller>().notifies.removeWhere((element) => element.id == id);
    archieveNotifies.removeWhere((element) => element.id == id);
    Get.find<Controller>().deleteNotification(id);
    Get.find<Controller>().safeAll();
    update();
  }
}
