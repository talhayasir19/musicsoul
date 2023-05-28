import 'package:flutter/material.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:musicsoul/Screens/Albums%20Screen/AlbumSongs%20Screen/AlbumSongs.dart';
import 'package:provider/provider.dart';
import 'Components/ScreenBasicElements.dart';
import 'Provider/MainProvider.dart';
import 'Screens/Albums Screen/Albums.dart';
import 'Screens/Home Screen/home.dart';

void main() {
  runApp(const MyApp());
}

int indexSelected = 0;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Soul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: ((context) => MainProvider()),
          ),
          ChangeNotifierProvider(
            create: (context) => MediaPlayerProvider(),
          )
        ],
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget home;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();

    screens = [
      const Home(),
      WillPopScope(
        onWillPop: () async =>
            !await AlbumScreen.AlbumNavigtorKey.currentState!.maybePop(),
        child: Navigator(
          key: AlbumScreen.AlbumNavigtorKey,
          initialRoute: Albums.pageName,
          onGenerateRoute: (settings) {
            if (settings.name == Albums.pageName) {
              return MaterialPageRoute(
                builder: (context) => const AlbumScreen(),
              );
            } else {
              return MaterialPageRoute(builder: (context) => AlbumScreen());
            }
          },
        ),
      ),
      const Text("Playlists"),
      const Text("Favourites")
    ];
  }

  @override
  Widget build(BuildContext context) {
    initialize(context);
    return Scaffold(
      appBar: customAppBar(),
      drawer: const Drawer(),
      backgroundColor: const Color.fromRGBO(253, 253, 253, 1),
      //All the bottom bar screens in stack
      body: Consumer<MainProvider>(
          builder: ((context, provider, child) => Stack(
                children: [
                  //Indexed stack for showing main screen
                  IndexedStack(
                    index: provider.indexSelected,
                    children: screens,
                  ),
                  //Bottom media player which will be expandable
                ],
              ))),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
// //Bottom Player
//             SizedBox.expand(
//               //draggable scrollable sheet to make it scrollable up and down
//               child: DraggableScrollableSheet(
//                 initialChildSize: 0.1,
//                 minChildSize: 0.1,
//                 expand: true,
//                 controller: dcontroller,
//                 snap: true,
//                 snapSizes: const [0.1],
//                 builder:
//                     (BuildContext context, ScrollController scrollController) {
//                   dcontroller.addListener(
//                     //it changes the widget in the bottom box when scolled to some extent
//                     () {
//                       // if (dcontroller.size > 0.3 && dcontroller.size < 0.5) {
//                       //   _homeProvider.changeUp();
//                       // } else if (dcontroller.size > 0.1 &&
//                       //     dcontroller.size < 0.3) {
//                       //   _homeProvider.changeDown();
//                       // }
//                     },
//                   );
//                   return Consumer<HomeProvider>(
//                     builder: ((context, homeProvider, child) =>
//                         Transform.translate(
//                           offset: Offset(
//                               customWidth(size: 0),
//                               customClientHeight(
//                                   size: homeProvider.playerTransformValue)),
//                           child: InkWell(
//                               onTap: (() {}),
//                               child: MediaPlayer(
//                                 scrollController: scrollController,
//                                 bgColor: defaulColor,
//                                 isPlayer: homeProvider.isPlayer,
//                                 //cheking is first time song is played or not
//                                 song: played
//                                     ? homeProvider
//                                         .Songs[homeProvider.currentIndex!]
//                                     : SongModel({
//                                         "_display_name": "null",
//                                         "artist": "null",
//                                       }),
//                                 homeProvider: homeProvider,
//                               )),
//                         )),
//                   );
//                 },
//               ),
//             ),