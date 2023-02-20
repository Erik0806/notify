import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

class SoundRepository {
  final AudioPlayer audioPlayer = AudioPlayer();
  //TODO debug playSound method

  playSound(String notifyTitle) {
    final newString = notifyTitle.toLowerCase().split(' ');
    bool played = false;
    for (var word in newString) {
      word = word.toLowerCase();
      if (!played) {
        if (notifyTitle == 'For Frodo') {
          played = true;
          audioPlayer.play(AssetSource('for_frodo.mp3'));
        } else if (_kaenguru.contains(word)) {
          audioPlayer.play(AssetSource('scheissverein.mp3'));
          played = true;
        } else if (_hdr.contains(word)) {
          audioPlayer.play(AssetSource('rohirrim_charge_1.mp3'));
          played = true;
        }
        Logger().i('Played sound');
      }
    }
  }
}

final soundRepositoryProvider = Provider<SoundRepository>((ref) {
  return SoundRepository();
});

final _kaenguru = <String>[
  'marc-uwe',
  'kling',
  'känguru',
  'scheißverein',
  'nazi',
  'politik',
  'schützenverein',
];

final _hdr = <String>[
  'herr der ringe',
  'lord of the rings',
  'lotr',
  'hdr',
  'aragorn',
  'ring',
  'samweis',
  'baumbart',
  'silmarillion',
  'beren',
  'luthien',
];
