import 'package:flutter/material.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:musicsoul/Screens/Albums%20Screen/AlbumSongs%20Screen/AlbumSongs.dart';
import 'package:musicsoul/Screens/Playlists%20Screen/Playlists.dart';
import 'package:provider/provider.dart';
import 'Components/MediaPlayer.dart';
import 'Components/ScreenBasicElements.dart';
import 'Provider/AlbumProvider.dart';
import 'Provider/HomeProvider.dart';
import 'Provider/MainProvider.dart';
import 'Screens/Albums Screen/Albums.dart';
import 'Screens/Home Screen/home.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(const MyApp());
}

int indexSelected = 0;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late MediaPlayerProvider mediaPlayerProvider;

  //  late Tween<double> circularTween, triggerTweeen;
  final circularTween = Tween<double>(begin: 0, end: 2000);

  final triggerTween = Tween<double>(begin: 0, end: 20);

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
          ),
          ChangeNotifierProvider(
            create: (context) => HomeProvider(
                vsync: this,
                cduration: const Duration(seconds: 1500),
                tduration: const Duration(milliseconds: 400),
                circlularTween: circularTween,
                triggerTween: triggerTween),
          ),
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
  //Media player
  late DraggableScrollableController dcontroller;
  late HomeProvider homeProvider;
  late MediaPlayerProvider mediaPlayerProvider;

  @override
  void initState() {
    super.initState();
    dcontroller = DraggableScrollableController();

    screens = [
      const Home(),
      WillPopScope(
        onWillPop: () async =>
            !await Albums.AlbumNavigtorKey.currentState!.maybePop(),
        child: Navigator(
          key: Albums.AlbumNavigtorKey,
          initialRoute: Albums.pageName,
          onGenerateRoute: (settings) {
            if (settings.name == Albums.pageName) {
              return MaterialPageRoute(
                builder: (context) => const AlbumScreen(),
              );
            } else {
              return MaterialPageRoute(
                  builder: (context) => const AlbumScreen());
            }
          },
        ),
      ),
      WillPopScope(
        onWillPop: () async =>
            !await Playlists.PlaylistsNavigtorKey.currentState!.maybePop(),
        child: Navigator(
          key: Playlists.PlaylistsNavigtorKey,
          initialRoute: Playlists.pageName,
          onGenerateRoute: (settings) {
            if (settings.name == Playlists.pageName) {
              return MaterialPageRoute(
                builder: (context) => const PlaylistScreen(),
              );
            } else {
              return MaterialPageRoute(
                  builder: (context) => const PlaylistScreen());
            }
          },
        ),
      ),
      const Text("Favourites")
    ];
  }

  @override
  Widget build(BuildContext context) {
    initialize(context);
    homeProvider = Provider.of<HomeProvider>(context, listen: true);
    mediaPlayerProvider =
        Provider.of<MediaPlayerProvider>(context, listen: true);
    return Scaffold(
      appBar: customAppBar(),
      drawer: const Drawer(),
      backgroundColor: const Color.fromRGBO(253, 253, 253, 1),
      //All the bottom bar screens in stack
      body: Consumer<MainProvider>(
          builder: ((context, mainProvider, child) => Stack(
                children: [
                  //Indexed stack for showing main screen
                  IndexedStack(
                    index: mainProvider.indexSelected,
                    children: screens,
                  ),
                  //Bottom media player which will be expandable and will be shown on every screen
                  SizedBox.expand(
                      child: BottomExpandableMediaPlayer(
                    dcontroller: dcontroller,
                    mediaPlayerProvider: mediaPlayerProvider,
                    homeProvider: homeProvider,
                  )),
                ],
              ))),
      //Bottom bar
      bottomNavigationBar: const BottomBar(),
    );
  }
}
