import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:provider/provider.dart';

import '../Screens/Home/home.dart';
import 'ScreenBasicElements.dart';
import 'package:on_audio_query/on_audio_query.dart';

//Media Player
class MediaPlayer extends StatelessWidget {
  late ScrollController scrollController;
  late Color bgColor;
  late bool isPlayer;
  late String songName;
  late String songDesc;
  late SongModel song;
  late MediaPlayerProvider _mediaPlayerProvider;
  late HomeProvider homeProvider;
  static String position = "";
  MediaPlayer(
      {required this.scrollController,
      required this.bgColor,
      required this.isPlayer,
      required this.homeProvider,
      required this.song});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MediaPlayerProvider(),
        builder: ((context, child) {
          _mediaPlayerProvider =
              Provider.of<MediaPlayerProvider>(context, listen: false);
          return ListView(controller: scrollController, children: [
            Container(
                width: customWidth(),
                height: customHeight(size: 0.85),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: !isPlayer
                            ? [bgColor, bgColor]
                            : [
                                Color.fromRGBO(33, 30, 36, 1),
                                defaulColor,
                              ])),
                child: isPlayer
                    ? mainPlayer(song)
                    : songDetails(_mediaPlayerProvider, homeProvider, song)),
          ]);
        }));
  }

  static void songPosition() {
    StreamSubscription<Duration> x = player.positionStream.listen((event) {
      int sec = event.inSeconds % 60;
      int min = (event.inSeconds / 60).floor();
      String minute = min.toString().length <= 1 ? "0$min" : "$min";
      String second = sec.toString().length <= 1 ? "0$sec" : "$sec";

      position = formatedTime(timeInSecond: player.position.inSeconds);
    });
  }
}

formatedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute:$second";
}

Widget songDetails(MediaPlayerProvider mediaPlayerProvider,
    HomeProvider homeProvider, SongModel song) {
  return Padding(
    padding: EdgeInsets.only(top: customHeight(size: 0.014)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: customHeight(size: 0.009)),
          child: SizedBox(
            width: customWidth(size: 0.1),
            child: Icon(
              Icons.music_note,
              color: Colors.white,
              size: customFontSize(size: 0.06),
            ),
          ),
        ),
        SizedBox(
          width: customWidth(size: 0.45),
          height: customHeight(size: 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                song.displayName,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: customFontSize(size: 0.032),
                    fontWeight: FontWeight.w400),
              ),
              Text(
                song.artist!,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: customFontSize(size: 0.025),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ),
        InkWell(
          onTap: (() {
            // setState(() {});
          }),
          child: Image.asset(
            "Assets/icons/heart.png",
            width: customFontSize(size: 0.07),
            height: customFontSize(size: 0.07),
          ),
        ),
        SizedBox(
            width: customFontSize(size: 0.085),
            height: customFontSize(size: 0.085),
            child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: (() {
                  if (player.playing) {
                    player.stop();
                    mediaPlayerProvider.changeIcon();
                    //To control animation
                    homeProvider.stopSongAnimation();
                  } else {
                    player.play();
                    mediaPlayerProvider.changeIcon();
                    //To control animation
                    homeProvider.playSongAnimation(isFirst: false);
                  }
                }),
                child: Center(
                  child: Consumer<MediaPlayerProvider>(
                      builder: ((context, mediaPlayerProvider, child) => Icon(
                            mediaPlayerProvider.playpause,
                            size: customFontSize(size: 0.045),
                            color: Color.fromRGBO(23, 28, 38, 1),
                          ))),
                ))),
      ],
    ),
  );
}

Widget mainPlayer(SongModel song) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          //     margin: EdgeInsets.only(bottom: customClientHeight(size: 0.1)),
          width: customWidth(size: 0.3),
          height: 2,
        ),
        SizedBox(
          height: customClientHeight(size: 0.95),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: customClientHeight(size: 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: customWidth(size: 0.8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          song.displayName,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: customFontSize(size: 0.036),
                              color: Color.fromARGB(255, 216, 212, 212)),
                        ),
                      ),
                    ),
                    Text(
                      "Now Playing",
                      style: TextStyle(
                          fontSize: customFontSize(size: 0.028),
                          color: Color.fromARGB(255, 221, 218, 218)),
                    ),
                  ],
                ),
              ),
              Stack(alignment: Alignment.center, children: [
                Container(
                  //   margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(31, 35, 38, 1),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(8, 9, 10, 1),
                            offset: Offset(8, 8),
                            spreadRadius: 1,
                            blurRadius: 10),
                        // BoxShadow(
                        //     color: Color.fromRGBO(69, 64, 75, 1),
                        //     offset: Offset(-3, -3),
                        //     spreadRadius: 0,
                        //     blurRadius: 4)
                      ]),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.01),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1)
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.04),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1)
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.06),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1)
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.04),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1)
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.03),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1),
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.08),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1),
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.all(3.5),
                          width: 3,
                          height: customClientHeight(size: 0.02),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(51, 145, 151, 1),
                                Color.fromRGBO(8, 121, 136, 1)
                              ])),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    width: 176,
                    height: 176,
                    // margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(84, 70, 136, 1),
                      backgroundColor: Color.fromRGBO(51, 45, 54, 1),
                      value: 0.8,
                    ))
              ]),
              Container(
                // margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //showing song current position
                    Text(
                      MediaPlayer.position.toString(),
                      style: TextStyle(
                          color: Color.fromRGBO(108, 108, 110, 1),
                          fontSize: customFontSize(size: 0.022)),
                    ),
                    SizedBox(
                      height: 1,
                      width: customWidth(size: 0.6),
                      child: SliderTheme(
                          data: const SliderThemeData(
                              thumbColor: Colors.green,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 5)),
                          child: Slider(
                              activeColor: Color.fromRGBO(51, 145, 151, 1),
                              inactiveColor: Color.fromRGBO(17, 17, 20, 1),
                              value: 0.7,
                              onChanged: ((value) {}))),
                    ),
                    //showing song size
                    Text(
                      formatedTime(
                          timeInSecond:
                              played ? player.duration!.inSeconds : 0),
                      style: TextStyle(
                          color: Color.fromRGBO(108, 108, 110, 1),
                          fontSize: customFontSize(size: 0.022)),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: customClientHeight(size: 0.05),
                    left: customWidth(size: 0.1),
                    right: customWidth(size: 0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      //  margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
                      width: customWidth(size: 0.14),
                      height: customClientHeight(size: 0.07),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(36, 39, 41, 1),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(8, 9, 10, 1),
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                                blurRadius: 6),
                            BoxShadow(
                                color: Color.fromRGBO(103, 154, 158, 1),
                                offset: -Offset(1, 1),
                                spreadRadius: 0,
                                blurRadius: 1),
                          ]),
                      child: Icon(
                        Icons.navigate_before_outlined,
                        color: Color.fromRGBO(51, 145, 151, 1),
                        size: customFontSize(size: 0.06),
                      ),
                    ),
                    Container(
                      //   margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
                      width: customWidth(size: 0.2),
                      height: customClientHeight(size: 0.1),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(36, 39, 41, 1),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(8, 9, 10, 1),
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                                blurRadius: 6),
                            BoxShadow(
                                color: Color.fromRGBO(103, 154, 158, 1),
                                offset: -Offset(1, 1),
                                spreadRadius: 0,
                                blurRadius: 3),
                          ]),
                      child: Icon(
                        Icons.pause,
                        color: Color.fromRGBO(51, 145, 151, 1),
                        size: customFontSize(size: 0.07),
                      ),
                    ),
                    Container(
                      //   margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
                      width: customWidth(size: 0.14),
                      height: customClientHeight(size: 0.07),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(36, 39, 41, 1),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(8, 9, 10, 1),
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                                blurRadius: 6),
                            BoxShadow(
                                color: Color.fromRGBO(103, 154, 158, 1),
                                offset: -Offset(1, 1),
                                spreadRadius: 0,
                                blurRadius: 1),
                          ]),
                      child: Icon(
                        Icons.navigate_next_outlined,
                        color: Color.fromRGBO(51, 145, 151, 1),
                        size: customFontSize(size: 0.06),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
