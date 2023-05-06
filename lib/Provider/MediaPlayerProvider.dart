import 'package:flutter/material.dart';

class MediaPlayerProvider extends ChangeNotifier {
  IconData playpause = Icons.pause;
  void changeIcon() {
    if (playpause == Icons.pause) {
      playpause = Icons.play_arrow;
    } else {
      playpause = Icons.pause;
    }
    notifyListeners();
  }
}
