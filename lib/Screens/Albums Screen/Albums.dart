import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicsoul/Provider/AlbumProvider.dart';
import 'package:musicsoul/Screens/Albums%20Screen/AlbumSongs%20Screen/AlbumSongs.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../Components/ScreenBasicElements.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumScreen extends StatelessWidget {
  static GlobalKey<NavigatorState> AlbumNavigtorKey =
      GlobalKey<NavigatorState>();

  const AlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumProvider>(
      create: (context) => AlbumProvider(),
      builder: (context, child) => Albums(),
    );
  }
}

class Albums extends StatefulWidget {
  static String pageName = "/Albums";
  Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OnAudioQuery onQuery = OnAudioQuery();
  late AlbumProvider albumProvider;
  late Future<List<AlbumModel>> albumList;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 239, 239, 1),
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.only(
            left: customWidth(size: 0.035),
            right: customWidth(size: 0.035),
            top: customClientHeight(size: 0.02)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: customClientHeight(size: 0.02),
                  left: customWidth(size: 0.02)),
              child: Text(
                "Songs Albums",
                style: TextStyle(
                    shadows: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(1, 1))
                    ],
                    fontSize: customFontSize(size: 0.052),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Consumer<AlbumProvider>(
              builder: (context, albumProvider, child) {
                if (albumProvider.isLoad) {
                  return Expanded(
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.62,
                            mainAxisSpacing: customClientHeight(size: 0.03),
                            crossAxisSpacing: customClientHeight(size: 0.035)),
                        itemCount: albumProvider.listAlbums.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return AlbumSongsScreen(
                                        album: albumProvider
                                            .listAlbums[index].album,
                                      );
                                    },
                                  ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: customClientHeight(size: 0.0)),
                                  width: customWidth(size: 0.42),
                                  // height: customClientHeight(size: 0.4),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(2, 2),
                                          blurRadius: 4)
                                    ],
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child:
                                        Image.asset("Assets/icons/folder.png"),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 5, bottom: 2),
                                    child: AutoSizeText(
                                      albumProvider.listAlbums[index].album,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: customFontSize(size: 0.026),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "${albumProvider.listAlbums[index].numOfSongs} items",
                                    style: TextStyle(
                                        fontSize: customFontSize(size: 0.026),
                                        color:
                                            Color.fromARGB(255, 131, 128, 128)),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void getSongsAlbums() async {
    // albumList = await onQuery.queryAlbums();
    // onQuery.queryPlaylists();

    // List<SongModel> songList = await onQuery.querySongs();
    // for (int i = 0; i < songList.length; i++) {
    //   for (int j = 0; j < albumList.length; j++) {
    //     if (songList[i].album == albumList[j].album) {}
    //   }
    // }
  }
}
