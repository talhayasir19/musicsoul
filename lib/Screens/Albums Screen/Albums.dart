import 'package:flutter/material.dart';
import 'package:musicsoul/Provider/AlbumProvider.dart';
import 'package:provider/provider.dart';
import '../../Components/ScreenBasicElements.dart';
import 'AlbumWidgets.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AlbumProvider>(
      create: (context) => AlbumProvider(),
      builder: (context, child) => const Albums(),
    );
  }
}

class Albums extends StatefulWidget {
  static GlobalKey<NavigatorState> AlbumNavigtorKey =
      GlobalKey<NavigatorState>();
  static String pageName = "/Albums";
  const Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AlbumProvider albumProvider;
  @override
  Widget build(BuildContext context) {
    albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 239, 239, 1),
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.only(
            left: customWidth(size: 0.035),
            right: customWidth(size: 0.035),
            top: customClientHeight(size: 0.02)),
        //Colum widget which contains top text and bottom grid view with albums
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: customClientHeight(size: 0.02),
                  left: customWidth(size: 0.02)),
              //Top text
              child: Text(
                "Songs Albums",
                style: TextStyle(
                    shadows: const [
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
                //Checking whether all the albums are loaded then showing grid other wise circular progress bar
                if (albumProvider.isLoad) {
                  return Expanded(
                    //Grid view showing multiple albums fetched from the storage
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.62,
                            mainAxisSpacing: customClientHeight(size: 0.03),
                            crossAxisSpacing: customClientHeight(size: 0.035)),
                        itemCount: albumProvider.listAlbums.length,
                        itemBuilder: (context, index) {
                          //Songs album wiget showing album with its name and number of items
                          return SongsAlbumWidget(
                            context: context,
                            albumProvider: albumProvider,
                            index: index,
                          );
                        }),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
