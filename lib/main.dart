import 'package:flutter/material.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:provider/provider.dart';

import 'Components/BottomBar.dart';
import 'Components/ScreenBasicElements.dart';
import 'Provider/HomeProvider.dart';
import 'Provider/MainProvider.dart';
import 'Screens/Home/home.dart';

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
        ],
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget home;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    home = const Home();
    screens = [home, Text("Albums"), Text("Playlists"), Text("Favourites")];
  }

  @override
  Widget build(BuildContext context) {
    initialize(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(23, 28, 38, 1),
        title: const Text(
          "Music Soul",
          style: TextStyle(fontFamily: "Trajan Pro "),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: customWidth(size: 0.03)),
            child: const Icon(Icons.search),
          )
        ],
      ),
      drawer: Drawer(),
      backgroundColor: const Color.fromRGBO(253, 253, 253, 1),
      body: Center(
          child: Consumer<MainProvider>(
              builder: ((context, provider, child) => IndexedStack(
                    children: [
                      home,
                      Text("Albums"),
                      Text("Playlists"),
                      Text("Favourites")
                    ],
                    index: provider.indexSelected,
                  )))),
      bottomNavigationBar: BottomBar(),
    );
  }
}
   // screens.elementAt(provider.indexSelected)))