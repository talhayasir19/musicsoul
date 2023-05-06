import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:musicsoul/Components/ScreenBasicElements.dart';
import 'package:musicsoul/Provider/HomeProvider.dart';
import 'package:musicsoul/Provider/MainProvider.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late MainProvider provider;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MainProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 28, 38, 1),
        border:
            Border.all(width: 0, color: const Color.fromRGBO(23, 28, 38, 1)),
      ),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  width: 0, color: const Color.fromRGBO(23, 28, 38, 1)),
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          width: customWidth(),
          height: customHeight(size: 0.076),
          child: Consumer<MainProvider>(
              builder: ((context, provider, child) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      bottomBarItem(
                        index: 0,
                        labelText: "Home",
                        icon: provider.isSelected[0]
                            ? Icons.home
                            : Icons.home_outlined,
                      ),
                      bottomBarItem(
                        index: 1,
                        labelText: "Albums",
                        icon: provider.isSelected[1]
                            ? Icons.folder
                            : Icons.folder_outlined,
                      ),
                      bottomBarItem(
                        index: 2,
                        labelText: "Playlists",
                        icon: provider.isSelected[2]
                            ? Icons.playlist_add_check_circle_rounded
                            : Icons.playlist_add_check,
                      ),
                      bottomBarItem(
                        index: 3,
                        labelText: "Favourites",
                        icon: provider.isSelected[3]
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                      ),
                    ],
                  )))),
    );
  }

  Widget bottomBarItem(
      {required String labelText,
      required IconData icon,
      required int index,
      Color? color}) {
    color = provider.isSelected[index]
        ? const Color.fromRGBO(23, 28, 38, 1)
        : const Color.fromRGBO(116, 116, 119, 1);
    return InkWell(
      onTap: (() {
        provider.setSelected(index);
      }),
      child: Container(
        width: customWidth(size: 0.2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            icon,
            color: color,
            size: customFontSize(size: 0.055),
          ),
          FittedBox(
            child: Text(
              labelText,
              style: TextStyle(
                  color: color, fontSize: customFontSize(size: 0.023)),
            ),
          )
        ]),
      ),
    );
  }
}

TextStyle labelStyle() {
  return TextStyle(
      fontFamily: "rubik",
      fontWeight: FontWeight.normal,
      fontSize: customFontSize(size: 0.021));
}
