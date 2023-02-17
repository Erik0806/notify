import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SoundRepository {
  final AudioPlayer audioPlayer = AudioPlayer();

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
          audioPlayer.play(AssetSource('rohirrim_charge.mp3'));
          played = true;
          //play Rohirrim theme TODO
        }
      }
    }
    //TODO refactor to use split correctly

    //TODO make to work
    // audioPlayer.play(
    //   AssetSource('scheissverein.mp3'),
    // );
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
  'Llord of the rings',
  'aragorn',
  'ring',
  'samweis',
  'baumbart',
  'silmarillion',
  'beren'
      'luthien',
];
