import 'package:audioplayers/audioplayers.dart';
import 'package:music_therapy/main/model/global_controller.dart';
import 'package:music_therapy/main/model/user_data.dart';
import 'package:music_therapy/main/service/MusicService.dart';
import 'package:music_therapy/main/service/base_url.dart';

import 'Music.dart';

class GlobalMusic {
  static final AudioPlayer globalAudioPlayer = AudioPlayer()
    ..onPlayerComplete.listen((event) {nextSong();});

  static PlayerState globalPlayerState = PlayerState.stopped;

  // Private backing field for music
  static Music _music = Music.example;

  static List<Music> musicList = [_music];

  static int index = -1;

  static Source globalSource = UrlSource("http://172.22.118.20:8080/music/IYJp72k1.wav");

  static Duration globalPosition = Duration.zero;

  static MusicService service = MusicService();

  // Creating a variable for the total duration of the audio
  static Duration globalDuration = const Duration(seconds: 3);

  // Getter for music
  static Music get music => _music;

  // Setter for music
  static set music(Music newMusic) {
    Music.recentPlayedList.insert(0, newMusic);
    globalAudioPlayer.pause();
    stopsAnimation();
    globalPlayerState = PlayerState.paused;
    _music = newMusic;
    // Update the global source with the new music file
    globalSource = UrlSource(baseUrl + "/music/" + newMusic.file);//AssetSource(newMusic.file);
    // Reset the global position to zero
    globalPosition = Duration.zero;
    // Set the global duration to the new music's duration
    globalDuration = Duration(seconds: newMusic.duration);

    service.addRecent(UserData.userId, newMusic.musicId);
    
    globalAudioPlayer.play(globalSource);

    startAnimation();
    globalPlayerState = PlayerState.playing;
  }

  
  static void nextSong() {
    if (GlobalMusic.index + 1 == GlobalMusic.musicList.length) return;
    index++;
    GlobalMusic.music = GlobalMusic.musicList[index];
  }

  static void previousSong() {
    if (GlobalMusic.index == 0) return;
    index--;
    GlobalMusic.music = GlobalMusic.musicList[index];
  }
}
