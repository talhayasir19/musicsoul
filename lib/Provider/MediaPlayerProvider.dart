import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MediaPlayerProvider extends ChangeNotifier {
  List<SongModel> mediaSongs = [];
  bool load = false;
  late OnAudioQuery onQuery;

  int? currentIndex;
  bool isPlayer = false;
  //setting media player songs
  void setSongs(List<SongModel> songs) {
    // mediaSongs.clear();
    mediaSongs = songs;
    notifyListeners();
  }

  void changeUp() {
    if (!isPlayer) {
      isPlayer = true;
      notifyListeners();
      print("Up");
    }
  }

  void changeDown() {
    if (isPlayer) {
      isPlayer = false;
      notifyListeners();
      print("Down");
    }
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  //
  IconData playpause = Icons.pause;
  double volume = 0.0;
  int songPosition = 0;
  bool isMenuActive = false;
  void setVolume(double svolume) {
    volume = svolume;
    notifyListeners();
  }

  void setSongPosition(int position) {
    songPosition = position;
    notifyListeners();
  }

  void setMenuActive() {
    if (isMenuActive) {
      isMenuActive = false;
    } else {
      isMenuActive = true;
    }
    notifyListeners();
  }

  void resetIcon() {
    playpause = Icons.pause;
    notifyListeners();
  }

  void changeIcon() {
    if (playpause == Icons.pause) {
      playpause = Icons.play_arrow;
    } else {
      playpause = Icons.pause;
    }
    notifyListeners();
  }
}
