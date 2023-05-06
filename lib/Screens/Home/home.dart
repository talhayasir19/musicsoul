import 'package:musicsoul/Components/MediaPlayer.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Screens/Home/homeWidgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/ScreenBasicElements.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../Components/Painters/MusicPlayingAnimation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

AudioPlayer player = AudioPlayer();
bool played = false;

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late OnAudioQuery onQuery;
  bool isPlayer = false;

  late Tween<double> circularTween, triggerTweeen;
  late DraggableScrollableController dcontroller;
  late HomeProvider _homeProvider;

  int? currentIndex;
  @override
  void initState() {
    super.initState();
    // getSongs();
    circularTween = Tween<double>(begin: 0, end: 2000);
    triggerTweeen = Tween<double>(begin: 0, end: 20);
    dcontroller = DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
        create: (context) => HomeProvider(
            vsync: this,
            cduration: const Duration(seconds: 1500),
            tduration: const Duration(milliseconds: 400),
            circlularTween: circularTween,
            triggerTween: triggerTweeen),
        builder: ((context, child) {
          _homeProvider = Provider.of<HomeProvider>(context, listen: false);
          return Scaffold(
              body: SizedBox(
            width: screenWidth,
            height: clientHeight,
            child: Stack(alignment: Alignment.center, children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: customWidth(size: 0.05),
                        right: customWidth(size: 0.05)),
                    width: customWidth(),
                    height: customHeight(size: 0.31),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: customWidth(),
                          height: customHeight(size: 0.22),
                          child:
                              Stack(alignment: Alignment.topCenter, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<HomeProvider>(
                                  builder: ((context, homeProvider, child) =>
                                      Container(
                                          height: customHeight(size: 0.18),
                                          child: CircularPlayer(
                                              imageRotateAngle: homeProvider
                                                  .cAnimation.value))),
                                ),
                                SizedBox(
                                  width: customWidth(size: 0.4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 6),
                                        child: Text(
                                          "Songs",
                                          style: TextStyle(
                                              fontSize:
                                                  customFontSize(size: 0.05),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Consumer<HomeProvider>(
                                        builder: ((context, homeProvider,
                                                child) =>
                                            Text(
                                              "${homeProvider.Songs.length} Songs • Device Storage",
                                              style: TextStyle(
                                                  fontSize: customFontSize(
                                                      size: 0.022),
                                                  fontWeight: FontWeight.normal,
                                                  color: const Color.fromARGB(
                                                      255, 139, 131, 131)),
                                            )),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            //Music animation painter
                            Consumer<HomeProvider>(
                                builder: ((context, homeProvider, child) =>
                                    Positioned(
                                      left: customWidth(size: 0.3),
                                      child: Container(
                                        color: Color.fromRGBO(255, 101, 80, 0),
                                        width: customWidth(size: 0.2),
                                        height: customHeight(size: 0.22),
                                        child: Transform.rotate(
                                          origin: Offset(0,
                                              -customHeight(size: 0.22) * 0.36),
                                          angle: degToRad(
                                              homeProvider.tAnimation.value),
                                          child: CustomPaint(
                                            painter: MusicStarterPainter(),
                                          ),
                                        ),
                                      ),
                                    ))),
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
                          ]),
                        ),
                        //Play and shuffle button
                        Consumer<HomeProvider>(
                            builder: ((context, homeProvider, child) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    bigButton(
                                        bgColor: Color.fromRGBO(23, 28, 38, 1),
                                        color: Colors.white,
                                        onPressed: () {},
                                        icon: Icons.loop,
                                        text: "Play"),
                                    bigButton(
                                        bgColor: Color(0xFFF3F5F7),
                                        color: Colors.black,
                                        onPressed: () {
                                          homeProvider.stopSongAnimation();
                                        },
                                        icon: Icons.shuffle,
                                        text: "Shuffle"),
                                  ],
                                )))
                      ],
                    ),
                  ),
                  //List of songs
                  Consumer<HomeProvider>(
                      builder: ((context, homeProvider, child) => Expanded(
                            child: (homeProvider.load)
                                ? SizedBox(
                                    child: ListView.builder(
                                        itemCount: homeProvider.Songs.length,
                                        itemBuilder: ((context, index) {
                                          return songTile(
                                              songs: homeProvider.Songs,
                                              index: index,
                                              onClick: (() {
                                                // currentIndex = index;
                                                homeProvider.playSongAnimation(
                                                    index: index,
                                                    isFirst: true);
                                              }));
                                        })),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ))),
                ],
              ),
              //Bottom Player
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.1,
                  minChildSize: 0.1,
                  expand: true,
                  controller: dcontroller,
                  snap: true,
                  snapSizes: const [0.1],
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    dcontroller.addListener(
                      () {
                        if (dcontroller.size > 0.2 && dcontroller.size < 0.3) {
                          isPlayer = true;
                        } else if (dcontroller.size > 0.1 &&
                            dcontroller.size < 0.2) {
                          isPlayer = false;
                        }
                      },
                    );
                    return Consumer<HomeProvider>(
                      builder: ((context, homeProvider, child) =>
                          Transform.translate(
                            offset: Offset(
                                0,
                                customClientHeight(
                                    size: homeProvider.playerTransformValue)),
                            child: InkWell(
                                onTap: (() {}),
                                child: Consumer<HomeProvider>(
                                    builder: ((context, homeProvider, child) =>
                                        MediaPlayer(
                                          scrollController: scrollController,
                                          bgColor: defaulColor,
                                          isPlayer: isPlayer,
                                          song: played
                                              ? homeProvider.Songs[
                                                  homeProvider.currentIndex!]
                                              : SongModel({
                                                  "_display_name": "null",
                                                  "artist": "null",
                                                }),
                                          homeProvider: _homeProvider,
                                        )))),
                          )),
                    );
                  },
                ),
              ),
            ]),
          ));
        }));
  }
}
