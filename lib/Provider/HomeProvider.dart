import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musicsoul/Components/MediaPlayer.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Screens/Home Screen/home.dart';

class HomeProvider extends ChangeNotifier {
  //to show and hide the options menu
  bool isMenuActive = false;
  //Animation elements
  TickerProvider vsync;
  Duration cduration, tduration;
  List<SongModel> Songs = [];

  bool load = false;
  late OnAudioQuery onQuery;
  AnimationController circularController, triggerController;
  Tween<double> circlularTween, triggerTween;
  late Animation<double> cAnimation, tAnimation;
  int currentIndex = 0;
  double playerTransformValue = 0.1;
  //for changing widget when scrolling
  bool isPlayer = false;
  void setMenuActive() {
    if (isMenuActive) {
      isMenuActive = false;
    } else {
      isMenuActive = true;
    }
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

  //set list of songs
  void setSongs(List<SongModel> songs) {
    Songs = songs;
    notifyListeners();
  }

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
      currentIndex = index!;
    }

    played = true;
    MediaPlayer.songPosition();
    notifyListeners();
  }

  void stopSongAnimation() {
    circularController.stop();
    triggerController.reverse();
  }

  //Function to get songs

  void getSongs() async {
    onQuery = OnAudioQuery();
    PermissionStatus status = await Permission.audio.request();
    if (status.isPermanentlyDenied) {
      await Permission.audio.request();
    }
    if (status.isGranted) {
      List<SongModel> x = await onQuery.querySongs();
      for (SongModel song in x) {
        listSongs.add(song);
        if (song.fileExtension == "mp3" || song.fileExtension == "m4aa") {
          Songs.add(song);
        }
      }
    }
    load = true;
    notifyListeners();
  }
}
