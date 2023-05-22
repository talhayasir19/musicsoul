import 'package:flutter/material.dart';
import 'package:musicsoul/Provider/MediaPlayerProvider.dart';
import 'package:provider/provider.dart';
import 'Components/ScreenBasicElements.dart';
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
      const Text("Albums"),
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
      body: Center(
          child: Consumer<MainProvider>(
              builder: ((context, provider, child) => IndexedStack(
                    index: provider.indexSelected,
                    children: screens,
                  )))),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
