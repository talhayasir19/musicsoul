import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicsoul/Components/MediaPlayer.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:provider/provider.dart';

import '../../Components/ScreenBasicElements.dart';
import '../../Components/Painters/MusicPlayingAnimation.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'home.dart';

//Top area widget with songs playing animation and text with number of songs
class topAreaWidget extends Stack {
  topAreaWidget({super.key})
      : super(alignment: Alignment.topCenter, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Circular song playing animation on left side
              circularSongPlayerAnimation(),
              //Songs and total songs text showing on right side
              songsNumber()
            ],
          ),
          //Circular animation starter painter placed on top of circular player animation
          Consumer<HomeProvider>(
              builder: ((context, homeProvider, child) => Positioned(
                    left: customWidth(size: 0.3),
                    child: Container(
                      color: const Color.fromRGBO(255, 101, 80, 0),
                      width: customWidth(size: 0.2),
                      height: customHeight(size: 0.22),
                      child: Transform.rotate(
                        origin: Offset(0, -customHeight(size: 0.22) * 0.36),
                        angle: degToRad(homeProvider.tAnimation.value),
                        child: CustomPaint(
                          painter: MusicStarterPainter(),
                        ),
                      ),
                    ),
                  ))),
          //top small square painter from which holder painting will be started placed in stack
          Positioned(
            left: customWidth(size: 0.3),
            child: Container(
              color: Color.fromRGBO(255, 101, 80, 0),
              width: customWidth(size: 0.2),
              height: customHeight(size: 0.22),
              child: CustomPaint(
                painter: MusicHolderPainter(),
              ),
            ),
          )
        ]);
}

//Circular Animation showing song playing
Widget circularSongPlayerAnimation() {
  return Consumer<HomeProvider>(
    builder: ((context, homeProvider, child) => SizedBox(
        height: customHeight(size: 0.18),
        child: Stack(alignment: Alignment.center, children: [
          Container(
            //decoration for creating shadow
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
              //cicle painter around the image
              child: CustomPaint(
                painter: customCircle(),
              ),
            ),
          ),
          //image which will be rotated
          ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Transform.rotate(
              angle: homeProvider.cAnimation.value,
              child: Image.asset(
                "Assets/images/guitar.jpg",
                width: 108,
                height: 108,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ]))),
  );
}

//Text widget showing number of songs
class songsNumber extends SizedBox {
  songsNumber({super.key})
      : super(
          width: customWidth(size: 0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                //Text widget with Songs text
                child: Text(
                  "Songs",
                  style: TextStyle(
                      fontSize: customFontSize(size: 0.05),
                      fontWeight: FontWeight.bold),
                ),
              ),
              //Text widget showing number of songs
              Consumer<HomeProvider>(
                builder: ((context, homeProvider, child) => Text(
                      //getting songs number from songs list
                      "${homeProvider.Songs.length} Songs • Device Storage",
                      style: TextStyle(
                          fontSize: customFontSize(size: 0.022),
                          fontWeight: FontWeight.normal,
                          color: const Color.fromARGB(255, 139, 131, 131)),
                    )),
              ),
            ],
          ),
        );
}

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

//Tile of songs showing song details

Widget songTile(BuildContext context,
    {required List<SongModel> songs,
    required HomeProvider homeProvider,
    required int index,
    required VoidCallback onClick}) {
  return InkWell(
    onTap: (() {
      playSong(context, Songs: songs, index: index);
      //for playing animation
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
                //Text showing song number in the list
                child: Text(
                  (getIndex(index)),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: customFontSize(size: 0.03),
                      color: Color.fromARGB(255, 58, 55, 55)),
                ),
              ),
            ),
            //widget showing song name and duration
            SizedBox(
              width: customWidth(size: 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //song name
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
                  //song duration in bottom
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
            //three dots button for song options
            InkWell(
                onTap: (() {
                  homeProvider.setMenuActive();
                }),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: customWidth(size: 0.1),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Image.asset("Assets/icons/dots.png"),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

//Function to play the song
void playSong(BuildContext context,
    {required List<SongModel> Songs, required int index}) async {
  player.dispose();
  player = AudioPlayer();
  //Provider.of<HomeProvider>(context).setSongs(Songs);
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
  player.playbackEventStream.listen((event) {
    if (event.processingState == ProcessingState.completed) {
      context.read<HomeProvider>().stopSongAnimation();
    }
  });
}

//returns index of song by adding zero
String getIndex(int index) {
  return index < 9 ? "0${index + 1}" : (index + 1).toString();
}

//returns properly formatted duration
String songsDuration(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

//Hover menu for song setting
class HomeSongOptionsMenu extends Container {
  HomeProvider provider;
  HomeSongOptionsMenu({required this.provider})
      : super(
          color: const Color.fromRGBO(0, 0, 0, 0.7),
          width: customWidth(),
          height: customClientHeight(),
          child: Column(
            //Buttons
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: customHeight(size: 0.15),
                        right: customWidth(size: 0.06)),
                    width: customFontSize(size: 0.1),
                    height: customFontSize(size: 0.1),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(23, 28, 38, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: customFontSize(size: 0.1),
                    height: customFontSize(size: 0.1),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.bell,
                        color: Color.fromRGBO(23, 28, 38, 1),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: customHeight(size: 0.15),
                        left: customWidth(size: 0.06)),
                    width: customFontSize(size: 0.1),
                    height: customFontSize(size: 0.1),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {},
                      child: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(23, 28, 38, 1),
                      ),
                    ),
                  ),
                ],
              ),
              //Cross button for closing menu
              Container(
                margin: EdgeInsets.only(top: customHeight(size: 0.02)),
                width: customFontSize(size: 0.09),
                height: customFontSize(size: 0.09),
                child: FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(23, 28, 38, 1),
                  onPressed: () {
                    provider.setMenuActive();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
}
