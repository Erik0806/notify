import 'dart:convert';

class Notify implements Comparable {
  DateTime fireTime;
  String text;
  int id;
  bool firstTimeOpen = true;

  Notify(
      {required this.fireTime,
      required this.text,
      required this.id,
      this.firstTimeOpen = true});

  //Test this code
  factory Notify.fromJson(Map<String, dynamic> jsonData) {
    String fireTimeString = jsonData['fireTime'];
    List<String> fireTimeList = fireTimeString.split('.');
    DateTime fireTime = DateTime(
      int.parse(fireTimeList[4]),
      int.parse(fireTimeList[3]),
      int.parse(fireTimeList[2]),
      int.parse(fireTimeList[0]),
      int.parse(fireTimeList[1]),
    );
    return Notify(
      fireTime: fireTime,
      text: jsonData['text'],
      id: jsonData['id'],
      firstTimeOpen: false,
    );
  }

  static Map<String, dynamic> toMap(Notify notify) => {
        'fireTime':
            '${notify.fireTime.hour}.${notify.fireTime.minute}.${notify.fireTime.day}.${notify.fireTime.month}.${notify.fireTime.year}',
        'text': notify.text,
        'id': notify.id,
      };

  static String encode(List<Notify> notifies) => json.encode(notifies
      .map<Map<String, dynamic>>((notify) => Notify.toMap(notify))
      .toList());

  static List<Notify> decode(String notifies) {
    if (notifies == '') {
      return [];
    }
    return (json.decode(notifies) as List<dynamic>)
        .map<Notify>((item) => Notify.fromJson(item))
        .toList();
  }

  @override
  int compareTo(other) {
    if (other is Notify) {
      if (fireTime.isBefore(other.fireTime)) {
        return -1;
      } else if (fireTime.isAfter(other.fireTime)) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }
}
