import 'package:flutter/material.dart';
import 'package:musicsoul/Screens/Home/home.dart';

class MediaPlayerProvider extends ChangeNotifier {
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
