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
import '../../../Provider/MediaPlayerProvider.dart';
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 223, 223, 1),
      body: SizedBox(
        //Top stack because we have to add the songs on the clipper
        child: Stack(
          children: [
            //This stack because we have to had two clippers on the top of each other the clipper

            Stack(
              alignment: Alignment.center,
              children: [
                //Clipper which will create white shade is on bottom
                ClipPath(
                  clipper: UpDownClipperShade(),
                  child: Container(
                    color: Colors.white,
                    width: customWidth(),
                    height: customClientHeight(size: 0.28),
                  ),
                ),
                //Second clipper on top which will create the curve type shape
                ClipPath(
                  clipper: UpDownClipper(),
                  child: Container(
                    color: const Color.fromRGBO(23, 28, 38, 1),
                    width: customWidth(),
                    height: customClientHeight(size: 0.28),
                    //In center there are two text widgets showing album name and number of items
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
                          //text showing album name
                          AutoSizeText(
                            widget.albumName,
                            minFontSize: 16,
                            maxLines: 1,
                            style: TextStyle(
                                shadows: const [
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
                              //Text showing number of songs in the album
                              child: AutoSizeText(
                                "${value.listAlbumSongs.length} items",
                                minFontSize: 12,
                                maxLines: 1,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 173, 168, 168),
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
                            //click listner
                            //First reset icon so when song will start icon will be on play state
                            context.read<MediaPlayerProvider>().resetIcon();
                            //setting songs for media player
                            context
                                .read<MediaPlayerProvider>()
                                .setSongs(albumSongsProvider.listAlbumSongs);
                            //starting circular animation on home screen
                            context
                                .read<HomeProvider>()
                                .playSongAnimation(index: index, isFirst: true);
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
