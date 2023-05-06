import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicsoul/Components/MediaPlayer.dart';
import 'package:musicsoul/Screens/Home/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeProvider extends ChangeNotifier {
  //Animation elements
  TickerProvider vsync;
  Duration cduration, tduration;
  List<SongModel> Songs = [];
  bool load = false;
  late OnAudioQuery onQuery;
  AnimationController circularController, triggerController;
  Tween<double> circlularTween, triggerTween;
  late Animation<double> cAnimation, tAnimation;
  int? currentIndex;
  double playerTransformValue = 0.1;
  HomeProvider({
    required this.vsync,
    required this.cduration,
    required this.tduration,
    required this.circlularTween,
    required this.triggerTween,
  })  : circularController =
            AnimationController(vsync: vsync, duration: cduration),
        triggerController =
            AnimationController(vsync: vsync, duration: tduration) {
    triggerController.addListener(() {
      notifyListeners();
    });
    //Image Animation listners
    circularController.addListener(() {
      notifyListeners();
    });
    circularController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        circularController.repeat();
      }
    });
    cAnimation = circlularTween.animate(circularController);
    tAnimation = triggerTween.animate(triggerController);
//Getting songs from device storage
    getSongs();
  }

  void playSongAnimation({int? index, bool? isFirst}) {
    playerTransformValue == 0.1
        ? playerTransformValue = 0.0
        : playerTransformValue;
    circularController.forward();
    triggerController.forward();
    if (isFirst!) {
      currentIndex = index;
    }

    played = true;
    MediaPlayer.songPosition();
    notifyListeners();
  }

  void stopSongAnimation() {
    circularController.stop();
    triggerController.reverse();
  }

  void loader() {
    load = true;
    notifyListeners();
  }
  //Function to get songs

  void getSongs() async {
    onQuery = OnAudioQuery();

    List<SongModel> x = await onQuery.querySongs();
    for (SongModel song in x) {
      if (song.fileExtension == "mp3" || song.fileExtension == "m4aa") {
        Songs.add(song);
      }
    }
    load = true;
    notifyListeners();
  }
}
