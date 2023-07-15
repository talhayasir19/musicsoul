import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:musicsoul/Components/Local%20Database/LocalDb.dart';
import 'package:musicsoul/Components/Local%20Database/PLSongModel.dart';
import 'package:musicsoul/Provider/AlbumProvider.dart';
import 'package:musicsoul/Provider/PlaylistsProvider.dart';
import 'package:provider/provider.dart';

import '../../Components/ScreenBasicElements.dart';
import '../Albums Screen/AlbumWidgets.dart';
import 'PlayListsWidgets.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaylistProvider>(
      create: (context) => PlaylistProvider(),
      child: const Playlists(),
    );
  }
}

class Playlists extends StatefulWidget {
  static GlobalKey<NavigatorState> PlaylistsNavigtorKey =
      GlobalKey<NavigatorState>();

  static String pageName = "/Playlists";
  const Playlists({super.key});

  @override
  State<Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  final TextEditingController _textFieldController = TextEditingController();
  late PlaylistProvider playlistProvider;
  String? valueText;
  List<PLSongModel> listPlaylist = [];

  Future<void> _displayTextInputDialog(
      BuildContext context, PlaylistProvider playlistProvider) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter the Playlist name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "PlayList Name"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () async {
                  if (valueText!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter a valid name")));
                    Navigator.pop(context);
                  } else {
                    LocalDb db = LocalDb.createInstance();
                    int x = await db.createPlaylist(valueText!);
                    await playlistProvider.getlist();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Playlist Created Successfully")));

                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    playlistProvider = Provider.of<PlaylistProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: customWidth(size: 0.06),
                right: customWidth(size: 0.06),
                top: customClientHeight(size: 0.02)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Playlists",
                      style: TextStyle(
                          color: Colors.black,
                          shadows: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3,
                                offset: Offset(1, 1))
                          ],
                          fontSize: customFontSize(size: 0.052),
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 2),
                      child: AutoSizeText(
                        "16 Created playlists",
                        minFontSize: 12,
                        maxLines: 1,
                        style: TextStyle(
                            color: Color.fromARGB(255, 90, 85, 85),
                            fontSize: customFontSize(size: 0.009)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 45,
                  child: FloatingActionButton(
                    backgroundColor: Color.fromRGBO(23, 28, 38, 1),
                    child: const Icon(
                      Icons.add,
                      size: 22,
                      color: Color.fromARGB(255, 223, 216, 216),
                    ),
                    onPressed: () {
                      _displayTextInputDialog(context, playlistProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: customClientHeight(size: 0.02)),
            color: const Color.fromRGBO(23, 28, 38, 1),
            width: customWidth(),
            height: 0.2,
          ),
          //Grid view showing playlists
          Expanded(
            child: Consumer<PlaylistProvider>(
              builder: (context, playlistProvider, child) {
                return playlistProvider.isLoad
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: customWidth(size: 0.035),
                            right: customWidth(size: 0.035),
                            top: customClientHeight(size: 0.02)),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.62,
                                    mainAxisSpacing:
                                        customClientHeight(size: 0.03),
                                    crossAxisSpacing:
                                        customClientHeight(size: 0.035)),
                            itemCount: playlistProvider.listPlaylist.length,
                            itemBuilder: (context, index) {
                              //Songs album wiget showing album with its name and number of items
                              return SongsPlaylistWidget(
                                context: context,
                                name: playlistProvider.listPlaylist[index].name,
                                // albumProvider: Provider.of<AlbumProvider>(context),
                                index: index,
                              );
                            }),
                      )
                    : const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  //contains elements
  bool isPresent(String input) {
    for (int x = 0; x < listPlaylist.length; x++) {
      if (playlistProvider.listPlaylist[x].name == input) {
        return true;
      }
    }
    return false;
  }
}
