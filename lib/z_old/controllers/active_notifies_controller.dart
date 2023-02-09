import 'dart:math';

import 'package:get/get.dart';
import 'package:notify/z_old/controllers/controller.dart';

import '../models/notify.dart';

class ActiveNotifiesController extends GetxController {
  List<Notify> activeNotifies = [];
  bool newNode = true;

  ActiveNotifiesController() {
    newNode =
        Get.find<Controller>().sharedPreferences.getBool('neueNotiz') ?? true;
    getNotifies();
    Get.find<Controller>().pageController.addListener(() {
      if (Get.find<Controller>().pageController.page == 1 ||
          Get.find<Controller>().pageController.page == 2) {
        getNotifies();
      }
    });
  }

  void getNotifies() {
    DateTime now = DateTime.now();
    activeNotifies.clear();
    List<Notify> notifies = Get.find<Controller>().notifies;
    for (var notify in notifies) {
      if (now.isBefore(notify.fireTime)) {
        activeNotifies.add(notify);
      }
    }
    activeNotifies.sort(
      (a, b) => a.compareTo(b),
    );
    if (Get.find<Controller>().justStarted && newNode) {
      addNotify(true);
      Get.find<Controller>().justStarted = false;
    }
    update();
  }

  int addNotify([bool addAtBeginning = false]) {
    bool found = false;
    int id = 0;
    while (!found) {
      id = Random().nextInt(10000);
      List<Notify> notifies = Get.find<Controller>().notifies;
      bool found2 = true;
      for (var notify in notifies) {
        if (id == notify.id) {
          found2 = false;
        }
      }
      if (found2) {
        found = true;
      }
    }
    Notify notify = Notify(
      fireTime: DateTime.now().add(const Duration(hours: 1)),
      text: '',
      id: id,
    );
    if (addAtBeginning) {
      Get.find<Controller>().notifies.insert(0, notify);
      activeNotifies.insert(0, notify);
    } else {
      Get.find<Controller>().notifies.add(notify);
      activeNotifies.add(notify);
    }
    activeNotifies.sort(
      (a, b) => a.compareTo(b),
    );
    Get.find<Controller>().safeAll();
    Get.find<Controller>().createNotification(notify);
    update();
    return id;
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
    for (var i = 0; i < activeNotifies.length; i++) {
      if (activeNotifies[i].id == id) {
        place = i;
      }
    }
    if (place != -1) {
      activeNotifies[place].text = text;
      Notify notify = activeNotifies[place];
      Get.find<Controller>().createNotification(notify);
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
    for (var i = 0; i < activeNotifies.length; i++) {
      if (activeNotifies[i].id == id) {
        place = i;
      }
    }
    if (place != -1) {
      activeNotifies[place].fireTime = fireTime;
      Notify notify = activeNotifies[place];
      Get.find<Controller>().changeNotification(notify);
    }
    activeNotifies.sort(
      (a, b) => a.compareTo(b),
    );
    Get.find<Controller>().safeAll();
    update();
  }

  void deleteNotify(int id) {
    Get.find<Controller>().notifies.removeWhere((element) => element.id == id);
    activeNotifies.removeWhere((element) => element.id == id);
    Get.find<Controller>().deleteNotification(id);
    Get.find<Controller>().safeAll();
    update();
  }
}
