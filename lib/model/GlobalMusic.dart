import 'package:audioplayers/audioplayers.dart';

import 'Music.dart';


class GlobalMusic {
  static final AudioPlayer globalAudioPlayer = AudioPlayer();
  static PlayerState globalPlayerState = PlayerState.stopped;

  // Private backing field for music
  static Music _music = Music.example;

  // Getter for music
  static Music get music => _music;

  // Setter for music
  static set music(Music newMusic) {
    Music.recentPlayedList.insert(0, newMusic);
    globalAudioPlayer.pause();
    globalPlayerState = PlayerState.paused;
    _music = newMusic;
    // Update the global source with the new music file
    globalSource = AssetSource(newMusic.file);
    // Reset the global position to zero
    globalPosition = Duration.zero;
    // Set the global duration to the new music's duration
    globalDuration = Duration(seconds: newMusic.duration);
    // Additional logic to use with the audio player can be added here
    // For example, loading the new source into the audio player
    globalSource = AssetSource(newMusic.file);
    globalAudioPlayer.play(globalSource);
    globalPlayerState = PlayerState.playing;
  }

  static Source globalSource = AssetSource('audio/silence.mp3');

  static Duration globalPosition = Duration.zero;

  // Creating a variable for the total duration of the audio
  static Duration globalDuration = const Duration(seconds: 3);

}