import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notify/src/utils/logger.dart';

class SoundRepository {
  SoundRepository(this.ref);

  final AudioPlayer audioPlayer = AudioPlayer();

  Ref ref;

  void playSound(String notifyTitle) {
    var played = false;
    final betterNotifyTitle = notifyTitle.toLowerCase();

    if (betterNotifyTitle == 'for frodo') {
      played = true;
      audioPlayer.play(AssetSource('for_frodo.mp3'));
      ref.read(loggerProvider).i("Played sound 'for Frodo'");
    }

    for (final kenGuru in _kaenguru) {
      if (betterNotifyTitle.contains(kenGuru) && !played) {
        played = true;
        audioPlayer.play(AssetSource('scheissverein.mp3'));
        ref.read(loggerProvider).i("Played sound 'Scheißverein'");
      }
    }

    for (final hobbit in _hdr) {
      if (betterNotifyTitle.contains(hobbit) && !played) {
        played = true;
        audioPlayer.play(AssetSource('rohirrim_charge_1.mp3'));
        ref.read(loggerProvider).i("Played sound 'rohirrim charge'");
      }
    }
  }
}

final soundRepositoryProvider = Provider<SoundRepository>((ref) {
  return SoundRepository(ref);
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
