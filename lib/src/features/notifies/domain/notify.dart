import 'dart:convert';

class Notify implements Comparable<Notify> {
  Notify({
    required this.fireTime,
    required this.text,
    required this.id,
    this.firstTimeOpen = true,
  });

  //Test this code
  factory Notify.fromMap(Map<String, dynamic> jsonData) {
    final fireTimeString = jsonData['fireTime'].toString();
    final fireTimeList = fireTimeString.split('.');
    final fireTime = DateTime(
      int.parse(fireTimeList[4]),
      int.parse(fireTimeList[3]),
      int.parse(fireTimeList[2]),
      int.parse(fireTimeList[0]),
      int.parse(fireTimeList[1]),
    );
    return Notify(
      fireTime: fireTime,
      text: jsonData['text'].toString(),
      id: int.parse(jsonData['id'].toString()),
      firstTimeOpen: false,
    );
  }
  DateTime fireTime;
  String text;
  int id;
  bool firstTimeOpen = true;

  static Map<String, dynamic> toMap(Notify notify) => {
        'fireTime':
            // ignore: lines_longer_than_80_chars
            '${notify.fireTime.hour}.${notify.fireTime.minute}.${notify.fireTime.day}.${notify.fireTime.month}.${notify.fireTime.year}',
        'text': notify.text,
        'id': notify.id,
      };

  static String encode(List<Notify> notifies) => json.encode(
        notifies.map<Map<String, dynamic>>(Notify.toMap).toList(),
      );

  static List<Notify> decode(String notifies) {
    if (notifies == '') {
      return [];
    }
    return (json.decode(notifies) as List<dynamic>)
        .map<Notify>((item) => Notify.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  @override
  int compareTo(Notify other) {
    if (fireTime.isBefore(other.fireTime)) {
      return -1;
    } else if (fireTime.isAfter(other.fireTime)) {
      return 1;
    } else {
      return 0;
    }
  }
}
