import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:musicsoul/Components/Local%20Database/LocalDb.dart';
import 'package:musicsoul/Provider/AddNewSongsProvider.dart';
import 'package:musicsoul/Provider/PlayListSongsProvider.dart';
import 'package:musicsoul/Screens/Playlists%20Screen/PlaylistSongs%20Screen/AddNewPlaylist%20Screen/AddNewPlaylist.dart';
import 'package:provider/provider.dart';

import '../../../Components/ScreenBasicElements.dart';
import '../../../Provider/AlbumSongsProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../Provider/HomeProvider.dart';
import '../../../Provider/MediaPlayerProvider.dart';
import '../../Albums Screen/AlbumSongs Screen/AlbumSongs.dart';

import 'PlaylistSongsWidgets.dart';

class PlayListSongsScreen extends StatelessWidget {
  String playlist;
  String displayName;
  PlayListSongsScreen(
      {super.key, required this.playlist, required this.displayName});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlayListSongsProvider>(
      create: (context) => PlayListSongsProvider(playlist),
      builder: (context, child) => PlayListSongs(
        playListName: playlist,
        displayName: displayName,
      ),
    );
  }
}

class PlayListSongs extends StatefulWidget {
  String playListName;
  String displayName;
  static String pageName = "/PlayListSongs";

  PlayListSongs(
      {super.key, required this.playListName, required this.displayName});

  @override
  State<PlayListSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlayListSongs> {
  AlbumSongsProvider? albumSongsProvider;
  late DraggableScrollableController dcontroller;
  List<SongModel> songs = [];
  late PlayListSongsProvider playListSongsProvider;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    dcontroller = DraggableScrollableController();
    LocalDb db = LocalDb();
    await db.createTable(widget.playListName);
  }

  @override
  Widget build(BuildContext context) {
    playListSongsProvider = Provider.of<PlayListSongsProvider>(context);
    return Material(
      child: Scaffold(
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
                              widget.displayName,
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
                            Consumer<PlayListSongsProvider>(
                              builder: (context, value, child) => Padding(
                                padding: const EdgeInsets.only(top: 2, left: 2),
                                //Text showing number of songs in the album
                                child: AutoSizeText(
                                  "${value.playListSongList.length} items",
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
                child: Consumer<PlayListSongsProvider>(
                    builder: (context, playlistSongsProvider, child) {
                  if (playlistSongsProvider.isLoad) {
                    return ListView.builder(
                        itemCount:
                            playlistSongsProvider.playListSongList.length,
                        itemBuilder: ((context, index) {
                          //Song tile showing songs details
                          return Stack(children: [
                            songTile(context,
                                playListSongsProvider: playlistSongsProvider,
                                songs: playlistSongsProvider.playListSongList
                                    .toList(),
                                index: index, onClick: (() {
                              //click listner
                              //First reset icon so when song will start icon will be on play state
                              context.read<MediaPlayerProvider>().resetIcon();
                              //setting songs for media player
                              context.read<MediaPlayerProvider>().setSongs(
                                  playlistSongsProvider.playListSongList
                                      .toList());
                              //starting circular animation on home screen
                              context.read<HomeProvider>().playSongAnimation(
                                  index: index, isFirst: true);
                            }))
                          ]);
                        }));
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 45,
          child: FloatingActionButton(
            backgroundColor: Color.fromRGBO(23, 28, 38, 1),
            child: const Icon(
              Icons.add,
              size: 22,
              color: Color.fromARGB(255, 223, 216, 216),
            ),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      playListSongsProvider.playListSongList.length.toString() +
                          "remaining" +
                          playListSongsProvider.playListRemainingSongs.length
                              .toString())));
              await Future.delayed(Duration(seconds: 1));
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNewPlaylistScreen(
                  playlistName: widget.playListName,
                  onPop: () {
                    playListSongsProvider.getPlaylistSongs();
                  },
                  listSongs:
                      playListSongsProvider.playListRemainingSongs.toList(),
                ),
              ));
              // _displayTextInputDialog(context, playlistProvider);
            },
          ),
        ),
      ),
    );
  }
}
