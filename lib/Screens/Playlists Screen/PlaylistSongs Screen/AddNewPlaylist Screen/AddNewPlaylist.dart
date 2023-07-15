import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicsoul/Components/Local%20Database/LocalDb.dart';
import 'package:musicsoul/Components/ScreenBasicElements.dart';
import 'package:musicsoul/Provider/PlayListSongsProvider.dart';
import 'package:musicsoul/Provider/PlaylistsProvider.dart';
import 'package:musicsoul/Screens/Home%20Screen/home.dart';
import 'package:musicsoul/Screens/Playlists%20Screen/PlaylistSongs%20Screen/AddNewPlaylist%20Screen/AddNewSongsWidgets.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../Provider/AddNewSongsProvider.dart';
import '../../../../Provider/AlbumSongsProvider.dart';
import '../../../../Provider/MediaPlayerProvider.dart';

class AddNewPlaylistScreen extends StatelessWidget {
  String playlistName;
  List<SongModel> listSongs;
  Function onPop;

  AddNewPlaylistScreen(
      {super.key,
      required this.playlistName,
      required this.listSongs,
      required this.onPop});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddNewSongsProvider>(
        create: (context) => AddNewSongsProvider(listSongs.length),
        child: AddNewPlaylist(
          playlistName: playlistName,
          listSongs: listSongs,
          onPop: onPop,
        ));
  }
}

class AddNewPlaylist extends StatefulWidget {
  String playlistName;
  Function onPop;
  List<SongModel> listSongs;
  AddNewPlaylist(
      {super.key,
      required this.playlistName,
      required this.listSongs,
      required this.onPop});

  @override
  State<AddNewPlaylist> createState() => _AddNewPlaylistState();
}

class _AddNewPlaylistState extends State<AddNewPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewSongsProvider>(
        builder: (context, addNewSongsProvider, child) => Column(
              children: [
                Container(
                  width: customWidth(),
                  height: customHeight(size: 0.06),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: customWidth(size: 0.035),
                        right: customWidth(size: 0.035)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(
                            "Selected",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: customFontSize(size: 0.04),
                                color: Colors.black),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: customWidth(size: 0.025)),
                            child: Text(
                              addNewSongsProvider.noOfChecked.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: customFontSize(size: 0.036),
                                  color: Color.fromARGB(255, 112, 109, 109)),
                            ),
                          ),
                        ]),
                        InkWell(
                          onTap: () async {
                            int x = 0;
                            LocalDb localDb = LocalDb.createInstance();
                            for (int i = 0;
                                i < addNewSongsProvider.listCheckBox.length;
                                i++) {
                              if (addNewSongsProvider.listCheckBox[i]) {
                                localDb.addSongInPlaylist(widget.playlistName,
                                    listSongs[i].id.toString());
                                x++;
                              }
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(x > 1
                                    ? "$x Songs added to the playlist"
                                    : "$x Song added to the playlist")));
                            // widget.playListSongsProvider.getPlaylistSongs();
                            widget.onPop();
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "Assets/icons/tick.png",
                            width: customWidth(size: 0.06),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: addNewSongsProvider.listCheckBox.length,
                      itemBuilder: ((context, index) {
                        //Song tile showing songs details
                        return Stack(children: [
                          songTile(context,
                              addNewSongsProvider: addNewSongsProvider,
                              songs: widget.listSongs,
                              listCheck: addNewSongsProvider.listCheckBox,
                              index: index,
                              onClick: (() {}))
                        ]);
                      })),
                ),
              ],
            ));
  }
}
