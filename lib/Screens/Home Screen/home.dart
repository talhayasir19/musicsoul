import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicsoul/Components/MediaPlayer.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:musicsoul/Screens/Home/homeWidgets.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/ScreenBasicElements.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

//Madia player object in isolation so will be used anywhere in whole app
AudioPlayer player = AudioPlayer();
bool played = false;

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late OnAudioQuery onQuery;
  bool isPlayer = false;
  late Tween<double> circularTween, triggerTweeen;
  late DraggableScrollableController dcontroller;
  late HomeProvider _homeProvider;

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
            //Widgets placed in stack so we add media player in bottom with draggable sheet
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
                        //Top area widget showing song playing animation and song text
                        SizedBox(
                          width: customWidth(),
                          height: customHeight(size: 0.22),
                          child: topAreaWidget(),
                        ),
                        //Play and shuffle button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            bigButton(
                                bgColor: const Color.fromRGBO(23, 28, 38, 1),
                                color: Colors.white,
                                onPressed: () {},
                                icon: Icons.loop,
                                text: "Play"),
                            bigButton(
                                bgColor: const Color(0xFFF3F5F7),
                                color: Colors.black,
                                onPressed: () {},
                                icon: Icons.shuffle,
                                text: "Shuffle"),
                          ],
                        )
                      ],
                    ),
                  ),
                  //List of songs
                  Consumer<HomeProvider>(
                    builder: (context, homeProvider, child) => Expanded(
                      child: (homeProvider.load)
                          ? SizedBox(
                              child: ListView.builder(
                                  itemCount: homeProvider.Songs.length,
                                  itemBuilder: ((context, index) {
                                    //Song tile showing songs details
                                    return Stack(children: [
                                      songTile(context,
                                          homeProvider: homeProvider,
                                          songs: homeProvider.Songs,
                                          index: index, onClick: (() {
                                        context
                                            .read<MediaPlayerProvider>()
                                            .resetIcon();
                                        _homeProvider.playSongAnimation(
                                            index: index, isFirst: true);
                                      }))
                                    ]);
                                  })),
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  )
                ],
              ),
              //Bottom Player
              SizedBox.expand(
                //draggable scrollable sheet to make it scrollable up and down
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
                      //it changes the widget in the bottom box when scolled to some extent
                      () {
                        if (dcontroller.size > 0.3 && dcontroller.size < 0.5) {
                          _homeProvider.changeUp();
                        } else if (dcontroller.size > 0.1 &&
                            dcontroller.size < 0.3) {
                          _homeProvider.changeDown();
                        }
                      },
                    );
                    return Consumer<HomeProvider>(
                      builder: ((context, homeProvider, child) =>
                          Transform.translate(
                            offset: Offset(
                                customWidth(size: 0),
                                customClientHeight(
                                    size: homeProvider.playerTransformValue)),
                            child: InkWell(
                                onTap: (() {}),
                                child: Consumer<HomeProvider>(
                                    //Media player widget
                                    builder: ((context, homeProvider, child) =>
                                        MediaPlayer(
                                          scrollController: scrollController,
                                          bgColor: defaulColor,
                                          isPlayer: homeProvider.isPlayer,
                                          //cheking is first time song is played or not
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
              //top hover menu active when setting button is pressed of song tile
              Consumer<HomeProvider>(
                  builder: (context, homeProvider, child) =>
                      homeProvider.isMenuActive
                          ? HomeSongOptionsMenu(
                              provider: homeProvider,
                            )
                          : const SizedBox())
            ]),
          ));
        }));
  }
}
