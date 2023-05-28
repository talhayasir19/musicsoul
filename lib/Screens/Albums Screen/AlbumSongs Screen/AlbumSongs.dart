import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicsoul/Components/ScreenBasicElements.dart';
import 'package:musicsoul/Provider/AlbumSongsProvider.dart';
import 'package:musicsoul/Screens/Home%20Screen/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../Components/MediaPlayer.dart';
import '../../../Provider/HomeProvider.dart';
import 'AlbumsSongsWidgets.dart';

class AlbumSongsScreen extends StatelessWidget {
  String album;
  AlbumSongsScreen({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumSongsProvider>(
      create: (context) => AlbumSongsProvider(album),
      builder: (context, child) => AlbumSongs(
        albumName: album,
      ),
    );
  }
}

class AlbumSongs extends StatefulWidget {
  String albumName;
  static String pageName = "/AlbumSongs";

  AlbumSongs({super.key, required this.albumName});

  @override
  State<AlbumSongs> createState() => _AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {
  AlbumSongsProvider? albumSongsProvider;
  late DraggableScrollableController dcontroller;
  List<SongModel> songs = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    dcontroller = DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) {
    // albumSongsProvider =
    //     Provider.of<AlbumSongsProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color.fromRGBO(224, 223, 223, 1),
      body: SizedBox(
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipPath(
                  clipper: UpDownClipperShade(),
                  child: Container(
                    color: Colors.white,
                    width: customWidth(),
                    height: customClientHeight(size: 0.28),
                  ),
                ),
                ClipPath(
                  clipper: UpDownClipper(),
                  child: Container(
                    color: Color.fromRGBO(23, 28, 38, 1),
                    width: customWidth(),
                    height: customClientHeight(size: 0.28),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.only(
                          left: customWidth(size: 0.06),
                          right: customWidth(size: 0.06),
                          bottom: customClientHeight(size: 0.06)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            widget.albumName,
                            minFontSize: 16,
                            maxLines: 1,
                            style: TextStyle(
                                shadows: [
                                  Shadow(
                                    color: Color.fromARGB(255, 151, 145, 145),
                                    blurRadius: 8,
                                  )
                                ],
                                color: Colors.white,
                                fontSize: customFontSize(size: 0.075)),
                          ),
                          Consumer<AlbumSongsProvider>(
                            builder: (context, value, child) => Padding(
                              padding: const EdgeInsets.only(top: 2, left: 2),
                              child: AutoSizeText(
                                value.listAlbumSongs.length.toString() +
                                    " items",
                                minFontSize: 12,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 173, 168, 168),
                                    fontSize: customFontSize(size: 0.008)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
            //Songs
            Padding(
              padding: EdgeInsets.only(top: customClientHeight(size: 0.22)),
              child: Consumer<AlbumSongsProvider>(
                  builder: (context, albumSongsProvider, child) {
                if (albumSongsProvider.isLoad) {
                  return ListView.builder(
                      itemCount: albumSongsProvider.listAlbumSongs.length,
                      itemBuilder: ((context, index) {
                        //Song tile showing songs details
                        return Stack(children: [
                          songTile(context,
                              albumSongsProvider: albumSongsProvider,
                              songs: albumSongsProvider.listAlbumSongs,
                              index: index, onClick: (() {
                            // context.read<MediaPlayerProvider>().resetIcon();
                            // _homeProvider.playSongAnimation(
                            //     index: index, isFirst: true);
                          }))
                        ]);
                      }));
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

//Clipper for clipping top area from bottom
class UpDownClipperShade extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double centerWidth = width / 2;
    double centerHeight = height / 2;
    Path path = Path();
    path.moveTo(0, height * 0.52);
    path.quadraticBezierTo(
        width * 0.02, height * 0.8, width * 0.35, height * 0.78);
    path.lineTo(width * 0.7, height * 0.78);
    path.quadraticBezierTo(width, height * 0.78, width, height);
    path.lineTo(width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
