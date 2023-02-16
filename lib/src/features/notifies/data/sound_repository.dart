// import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SoundRepository {
  // AudioPlayer audioPlayer = AudioPlayer();

  playSound(String notifyTitle) {
    final newString = notifyTitle.toLowerCase().split(' ');
    //TODO refactor to use split correctly
    if (notifyTitle == 'For Frodo') {
      //play audio from scene in front of black gate TODO
    } else if (_kaenguru.contains(newString)) {
      //play scheißverein TODO
    } else if (_hdr.contains(newString)) {
      //play Rohirrim theme TODO
    }
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
