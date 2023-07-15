import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicsoul/Components/ScreenBasicElements.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Provider/MainProvider.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:provider/provider.dart';
import '../Screens/Home Screen/home.dart';
import '../main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'MediaPlayer.dart';

late Size size;
late double screenWidth,
    screenHeight,
    fontSize,
    clientHeight,
    topBarSize,
    bottomBarSize;
Color defaulColor = const Color.fromRGBO(23, 28, 38, 1),
    greyColor = Color.fromARGB(255, 99, 93, 93);

double customWidth({double size = 1}) {
  return screenWidth * size;
}

double customHeight({double size = 1}) {
  return screenHeight * size;
}

double customClientHeight({double size = 1}) {
  return clientHeight * size;
}

double customFontSize({double size = 0.05}) {
  return fontSize * size;
}

void initialize(BuildContext context) {
  size = MediaQuery.of(context).size;
  screenWidth = size.width;
  topBarSize = MediaQuery.of(context).padding.top;
  bottomBarSize = MediaQuery.of(context).padding.bottom;
  screenHeight = size.height - topBarSize;
  clientHeight = screenHeight - kToolbarHeight - kBottomNavigationBarHeight;
  fontSize = (screenWidth * 0.8 + screenHeight) / 2;
}

//App bar
class customAppBar extends AppBar {
  customAppBar()
      : super(
          backgroundColor: Color.fromRGBO(23, 28, 38, 1),
          title: const Text(
            "Music Soul",
            style: TextStyle(fontFamily: "Trajan Pro "),
          ),
          actions: [
            // Padding(
            //   padding: EdgeInsets.only(right: customWidth(size: 0.03)),
            //   child: const Icon(Icons.search),
            // )
          ],
        );
}

//Bottom bar
class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late MainProvider provider;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MainProvider>(context, listen: false);
    //Added to containers because bottom bar has round corners so to add black color in the remaining space
    //added another container in the background
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 28, 38, 0.0),
        border:
            Border.all(width: 0, color: const Color.fromRGBO(23, 28, 38, 0.0)),
      ),
      //main container with round corners
      child: UnconstrainedBox(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0, color: const Color.fromRGBO(23, 28, 38, 1)),
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            width: customWidth(),
            height: customHeight(size: 0.076),
            child: Consumer<MainProvider>(
                //Bottom bar elements
                builder: ((context, provider, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        bottomBarItem(
                          index: 0,
                          labelText: "Home",
                          icon: provider.isSelected[0]
                              ? Icons.home
                              : Icons.home_outlined,
                        ),
                        bottomBarItem(
                          index: 1,
                          labelText: "Albums",
                          icon: provider.isSelected[1]
                              ? Icons.folder
                              : Icons.folder_outlined,
                        ),
                        bottomBarItem(
                          index: 2,
                          labelText: "Playlists",
                          icon: provider.isSelected[2]
                              ? Icons.playlist_add_check_circle_rounded
                              : Icons.playlist_add_check,
                        ),
                        bottomBarItem(
                          index: 3,
                          labelText: "Favourites",
                          icon: provider.isSelected[3]
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                        ),
                      ],
                    )))),
      ),
    );
  }

  Widget bottomBarItem(
      {required String labelText,
      required IconData icon,
      required int index,
      Color? color}) {
    color = provider.isSelected[index]
        ? const Color.fromRGBO(23, 28, 38, 1)
        : const Color.fromRGBO(116, 116, 119, 1);
    return InkWell(
      onTap: (() {
        provider.setSelected(index);
      }),
      child: Container(
        width: customWidth(size: 0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        //Icons widget
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            icon,
            color: color,
            size: customFontSize(size: 0.055),
          ),
          //Bottom text widget
          FittedBox(
            child: Text(
              labelText,
              style: TextStyle(
                  color: color, fontSize: customFontSize(size: 0.023)),
            ),
          )
        ]),
      ),
    );
  }
}

TextStyle labelStyle() {
  return TextStyle(
      fontFamily: "rubik",
      fontWeight: FontWeight.normal,
      fontSize: customFontSize(size: 0.021));
}

//settings hover menu for showing song options
class SongOptionsMenu extends Container {
  MediaPlayerProvider provider;
  SongOptionsMenu({required this.provider})
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

//Bottom expandable media player
class BottomExpandableMediaPlayer extends DraggableScrollableSheet {
  DraggableScrollableController dcontroller;
  MediaPlayerProvider mediaPlayerProvider;
  HomeProvider homeProvider;
  BottomExpandableMediaPlayer(
      {required this.dcontroller,
      required this.mediaPlayerProvider,
      required this.homeProvider})
      : super(
          initialChildSize: 0.1,
          minChildSize: 0.1,
          expand: true,
          controller: dcontroller,
          snap: true,
          snapSizes: const [0.1],
          builder: (BuildContext context, ScrollController scrollController) {
            dcontroller.addListener(
              //it changes the widget in the bottom box when scolled to some extent
              () {
                if (dcontroller.size > 0.3 && dcontroller.size < 0.5) {
                  mediaPlayerProvider.changeUp();
                } else if (dcontroller.size > 0.1 && dcontroller.size < 0.3) {
                  mediaPlayerProvider.changeDown();
                }
              },
            );
            return Consumer<MediaPlayerProvider>(
              builder: ((context, mediaPlayerProvider, child) =>
                  Transform.translate(
                      offset: Offset(
                          customWidth(size: 0),
                          customClientHeight(
                              size: homeProvider.playerTransformValue)),
                      child: MediaPlayer(
                        scrollController: scrollController,
                        bgColor: defaulColor,
                        isPlayer: mediaPlayerProvider.isPlayer,
                        //cheking is first time song is played or not
                        song: played
                            ? mediaPlayerProvider
                                .mediaSongs[homeProvider.currentIndex]
                            : SongModel({
                                "_display_name": "null",
                                "artist": "null",
                              }),
                        homeProvider: homeProvider,
                      ))),
            );
          },
        );
}
