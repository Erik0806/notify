import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SoundRepository {
  AudioPlayer audioPlayer = AudioPlayer();

  playSound(String notifyTitle) {
    print('played');
    audioPlayer.play(
      AssetSource('scheissverein.mp3'),
    );
  }
}

final soundRepositoryProvider = Provider<SoundRepository>((ref) {
  return SoundRepository();
});
