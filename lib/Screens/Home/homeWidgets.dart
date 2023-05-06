import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicsoul/Components/MediaPlayer.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';

import '../../Components/ScreenBasicElements.dart';
import '../../Components/Painters/MusicPlayingAnimation.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'home.dart';

//Button widget
Widget bigButton(
    {required Color bgColor,
    required Color color,
    required VoidCallback onPressed,
    required IconData icon,
    required String text}) {
  return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          fixedSize: MaterialStatePropertyAll(
              Size(customWidth(size: 0.42), customHeight(size: 0.065))),
          backgroundColor: MaterialStatePropertyAll(bgColor)),
      onPressed: (onPressed),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: customFontSize(size: 0.035),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: customFontSize(size: 0.032), color: color),
            ),
          ),
        ],
      ));
}

//Animation showing song playing
Widget CircularPlayer({required double imageRotateAngle}) {
  return Stack(alignment: Alignment.center, children: [
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(250),
        color: Color.fromRGBO(237, 241, 244, 1.000),
        boxShadow: [
          BoxShadow(
              blurRadius: 4,
              spreadRadius: 1,
              color: Colors.grey.shade400,
              offset: Offset(4, 4)),
          BoxShadow(
              blurRadius: 4,
              spreadRadius: 1,
              color: Colors.grey.shade300,
              offset: Offset(-4, -4))
        ],
      ),
      width: 140,
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: CustomPaint(
          painter: customCircle(),
        ),
      ),
    ),
    ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: Transform.rotate(
        angle: imageRotateAngle,
        child: Image.asset(
          "Assets/images/guitar.jpg",
          width: 108,
          height: 108,
          fit: BoxFit.cover,
        ),
      ),
    ),
  ]);
}
//Tile of songs showing song details

Widget songTile(
    {required List<SongModel> songs,
    required int index,
    required VoidCallback onClick}) {
  return InkWell(
    onTap: (() {
      playSong(Songs: songs, index: index);
      onClick();
    }),
    child: Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.08)),
      ),
      width: customWidth(),
      height: customHeight(size: 0.095),
      child: Padding(
        padding: EdgeInsets.only(
            left: customWidth(size: 0.04), right: customWidth(size: 0.04)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: customWidth(size: 0.1),
              child: Center(
                child: Text(
                  (getIndex(index)),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: customFontSize(size: 0.03),
                      color: Color.fromARGB(255, 58, 55, 55)),
                ),
              ),
            ),
            SizedBox(
              width: customWidth(size: 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      songs[index].displayName.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: customFontSize(size: 0.029),
                          color: Colors.black),
                    ),
                  ),
                  Text(
                    "${songsDuration(Duration(milliseconds: songs[index].duration!))} • ${songs[index].artist!}",
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: customFontSize(size: 0.025),
                        color: const Color.fromARGB(255, 90, 87, 87)),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (() {}),
              child: SizedBox(
                width: customWidth(size: 0.1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Image.asset("Assets/icons/dots.png"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

//Function to play the song
void playSong({required List<SongModel> Songs, required int index}) async {
  player.dispose();
  player = AudioPlayer();
  // Define the playlist
  final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: Songs.map((e) => AudioSource.uri(Uri.parse(e.uri.toString())))
          .toList());
  //   player.stop();
  await player.setAudioSource(playlist,
      initialIndex: index, initialPosition: Duration.zero);
  player.play();
}

//returns index of song by adding zero
String getIndex(int index) {
  return index < 9 ? "0" + (index + 1).toString() : (index + 1).toString();
}

//returns properly formatted duration
String songsDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0)
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  else
    return "$twoDigitMinutes:$twoDigitSeconds";
}
