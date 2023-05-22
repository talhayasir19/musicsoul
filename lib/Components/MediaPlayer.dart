import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:provider/provider.dart';

import '../Screens/Home/home.dart';
import 'ScreenBasicElements.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:volume_controller/volume_controller.dart';

//Media Player
class MediaPlayer extends StatefulWidget {
  late ScrollController scrollController;
  late Color bgColor;
  late bool isPlayer;
  late SongModel song;
  late HomeProvider homeProvider;
  static String position = "";
  MediaPlayer(
      {required this.scrollController,
      required this.bgColor,
      required this.isPlayer,
      required this.homeProvider,
      required this.song});

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();

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

class _MediaPlayerState extends State<MediaPlayer> {
  late String songName;

  late String songDesc;

  late MediaPlayerProvider _mediaPlayerProvider;
  late HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _mediaPlayerProvider =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    _homeProvider = Provider.of<HomeProvider>(context);
    //Volume listener which will listner to the changes in device volume and will apply same changes to the
    //circular progress bar showing volume
    VolumeController().listener((volume) {
      _mediaPlayerProvider.setVolume(volume);
    });
    //position stream listner which will change the value of song position which we will aplly to slider in mediaplayer
    player.positionStream.listen((event) {
      _mediaPlayerProvider.setSongPosition(event.inSeconds);
    });
    //listning to current song index to update the song name when next song is player after one
    player.currentIndexStream.listen((event) {
      if (played) {
        _homeProvider.setCurrentIndex(player.currentIndex!);
      }
    });
    //used listview becuase we have use bottomscrollable sheet so it requires listview
    return ListView(controller: widget.scrollController, children: [
      Stack(children: [
        Container(
            width: customWidth(),
            height: customClientHeight(),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: !widget.isPlayer
                        ? [widget.bgColor, widget.bgColor]
                        : [
                            Color.fromRGBO(33, 30, 36, 1),
                            defaulColor,
                          ])),
            //isplayer which is true when media player is scrolled up otherwise shown small widget in bottom
            child: widget.isPlayer
                ? mainPlayer(widget.song, widget.homeProvider)
                : songDetails(
                    _mediaPlayerProvider, widget.homeProvider, widget.song)),
        //hover menu which will be active when setting button is pressed
        Consumer<MediaPlayerProvider>(
            //isMenuActive checks whether user has pressed settings button is not then show empty box
            builder: (context, mediaPlayerProvider, child) =>
                mediaPlayerProvider.isMenuActive
                    ? SongOptionsMenu(
                        provider: mediaPlayerProvider,
                      )
                    : const SizedBox())
      ]),
    ]);
  }
}

//songs details widget which is small box in bottom
Widget songDetails(MediaPlayerProvider mediaPlayerProvider,
    HomeProvider homeProvider, SongModel song) {
  return Padding(
    padding: EdgeInsets.only(top: customHeight(size: 0.014)),
    child: GestureDetector(
      onHorizontalDragEnd: (details) {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: customHeight(size: 0.009)),
            //First music icon
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
                //second colums which shows song name in top
                Text(
                  song.displayName,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: customFontSize(size: 0.032),
                      fontWeight: FontWeight.w400),
                ),
                //song artist name in bottom
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
          //Heart icon
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
          //Play and pause button of song
          SizedBox(
              width: customFontSize(size: 0.085),
              height: customFontSize(size: 0.085),
              child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.white),
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
    ),
  );
}

//Main player showing detailed options for song shown when scrolled up
Widget mainPlayer(SongModel song, HomeProvider homeProvider) {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: customWidth(size: 0.1),
                          right: customWidth(size: 0.1)),
                      //       width: customWidth(size: 0.8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          song.displayName,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: customFontSize(size: 0.036),
                              color: Color.fromARGB(255, 216, 212, 212)),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: customWidth(
                            size: 0.08,
                          ),
                        ),
                        Text(
                          "Now Playing",
                          style: TextStyle(
                              fontSize: customFontSize(size: 0.028),
                              color: Color.fromARGB(255, 221, 218, 218)),
                        ),
                        //Settings icon
                        Container(
                          margin:
                              EdgeInsets.only(right: customWidth(size: 0.02)),
                          width: customWidth(size: 0.08),
                          padding:
                              EdgeInsets.only(right: customWidth(size: 0.04)),
                          child: Consumer<MediaPlayerProvider>(
                            builder: (context, mediaPlayerProvider, child) =>
                                InkWell(
                              onTap: () {
                                mediaPlayerProvider.setMenuActive();
                              },
                              child: const Icon(
                                Icons.settings,
                                color: Color.fromARGB(255, 221, 218, 218),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //Center circular box showing song playing animation and current device volume in circle
              Stack(alignment: Alignment.center, children: [
                //Main container with circle shape
                Container(
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
                      ]),
                  //center bars which will be animated when song play
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        verticalBar(customClientHeight(size: 0.01)),
                        verticalBar(customClientHeight(size: 0.04)),
                        verticalBar(customClientHeight(size: 0.06)),
                        verticalBar(customClientHeight(size: 0.04)),
                        verticalBar(customClientHeight(size: 0.03)),
                        verticalBar(customClientHeight(size: 0.08)),
                        verticalBar(customClientHeight(size: 0.02)),
                      ],
                    ),
                  ),
                ),
                //circular progress indicator showing current device volume
                SizedBox(
                    width: 176,
                    height: 176,
                    child: Consumer<MediaPlayerProvider>(
                      builder: (context, mediaPlayerProvider, child) =>
                          CircularProgressIndicator(
                        color: const Color.fromRGBO(84, 70, 136, 1),
                        backgroundColor: const Color.fromRGBO(51, 45, 54, 1),
                        value: mediaPlayerProvider.volume,
                      ),
                    ))
              ]),

              //song slider widget with song position
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //showing song current position
                  Text(
                    MediaPlayer.position.toString(),
                    style: TextStyle(
                        color: const Color.fromRGBO(108, 108, 110, 1),
                        fontSize: customFontSize(size: 0.022)),
                  ),
                  //Songs slider
                  songSlider(),
                  //showing song length
                  Text(
                    formatedTime(timeInSecond: player.duration?.inSeconds ?? 0),
                    style: TextStyle(
                        color: const Color.fromRGBO(108, 108, 110, 1),
                        fontSize: customFontSize(size: 0.022)),
                  ),
                ],
              ),
              //Bottom three buttons
              //move to previous song button
              Container(
                margin: EdgeInsets.only(
                    bottom: customClientHeight(size: 0.05),
                    left: customWidth(size: 0.1),
                    right: customWidth(size: 0.1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          player.seekToPrevious();
                        },
                        child: sideButton(Icons.navigate_before_outlined)),
                    //playpause button
                    Consumer<MediaPlayerProvider>(
                      builder: (context, mediaPlayerProvider, child) => InkWell(
                          onTap: () {
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
                          },
                          child: centerButton(mediaPlayerProvider.playpause)),
                    ),
                    //Forward button
                    InkWell(
                        onTap: () async {
                          await player.seekToNext();
                        },
                        child: sideButton(Icons.navigate_next_outlined)),
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

//vertical small bar
Container verticalBar(double height) {
  return Container(
    margin: const EdgeInsets.all(3.5),
    width: 3,
    height: height,
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
          Color.fromRGBO(51, 145, 151, 1),
          Color.fromRGBO(8, 121, 136, 1)
        ])),
  );
}

//slider showing song position
SizedBox songSlider() {
  return SizedBox(
    width: customWidth(size: 0.65),
    child: SliderTheme(
      data: const SliderThemeData(
          thumbColor: Colors.green,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
      child: Consumer<MediaPlayerProvider>(
        builder: (context, mediaPlayerProvider, child) => SliderTheme(
          data: const SliderThemeData(
              thumbColor: Colors.green,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8)),
          child: Slider(
              max: player.duration?.inSeconds.toDouble() ?? 50,
              activeColor: const Color.fromRGBO(51, 145, 151, 1),
              inactiveColor: const Color.fromRGBO(17, 17, 20, 1),
              value: mediaPlayerProvider.songPosition.toDouble(),
              onChanged: ((value) {
                mediaPlayerProvider.setSongPosition(value.toInt());
                player.seek(Duration(seconds: value.toInt()));
              })),
        ),
      ),
    ),
  );
}

//Center button for playpause
Container centerButton(IconData icon) {
  return Container(
    //   margin: EdgeInsets.only(top: customClientHeight(size: 0.12)),
    width: customWidth(size: 0.2),
    height: customClientHeight(size: 0.1),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(36, 39, 41, 1),
        boxShadow: [
          const BoxShadow(
              color: Color.fromRGBO(8, 9, 10, 1),
              offset: Offset(4, 4),
              spreadRadius: 0,
              blurRadius: 6),
          BoxShadow(
              color: const Color.fromRGBO(103, 154, 158, 1),
              offset: -Offset(1, 1),
              spreadRadius: 0,
              blurRadius: 3),
        ]),
    child: Icon(
      icon,
      color: Color.fromRGBO(51, 145, 151, 1),
      size: customFontSize(size: 0.07),
    ),
  );
}

//move to next and previous song button
Container sideButton(IconData icon) {
  return Container(
    width: customWidth(size: 0.14),
    height: customClientHeight(size: 0.07),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromRGBO(36, 39, 41, 1),
        boxShadow: [
          const BoxShadow(
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
      icon,
      color: const Color.fromRGBO(51, 145, 151, 1),
      size: customFontSize(size: 0.06),
    ),
  );
}

//function to format time in string
formatedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute:$second";
}
