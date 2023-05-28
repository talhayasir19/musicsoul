//Tile of songs showing song details

import 'package:flutter/material.dart';
import 'package:musicsoul/Provider/AlbumProvider.dart';
import 'package:musicsoul/Provider/AlbumSongsProvider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../Components/ScreenBasicElements.dart';
import '../../Home Screen/homeWidgets.dart';

Widget songTile(BuildContext context,
    {required List<SongModel> songs,
    required AlbumSongsProvider albumSongsProvider,
    required int index,
    required VoidCallback onClick}) {
  return InkWell(
    onTap: (() {
      playSong(context, Songs: songs, index: index);
      //for playing animation
      onClick();
    }),
    child: Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.08)),
      ),
      width: customWidth(),
      height: customHeight(size: 0.095),
      child: Padding(
        padding: EdgeInsets.only(
            left: customWidth(size: 0.04), right: customWidth(size: 0.04)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: customWidth(size: 0.1),
              child: Center(
                //Text showing song number in the list
                child: Text(
                  (getIndex(index)),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: customFontSize(size: 0.03),
                      color: Color.fromARGB(255, 58, 55, 55)),
                ),
              ),
            ),
            //widget showing song name and duration
            SizedBox(
              width: customWidth(size: 0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //song name
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      songs[index].displayName.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: customFontSize(size: 0.029),
                          color: Colors.black),
                    ),
                  ),
                  //song duration in bottom
                  Text(
                    "${songsDuration(Duration(milliseconds: songs[index].duration!))} • ${songs[index].artist!}",
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: customFontSize(size: 0.025),
                        color: const Color.fromARGB(255, 90, 87, 87)),
                  ),
                ],
              ),
            ),
            //three dots button for song options
            InkWell(
                onTap: (() {
                  // homeProvider.setMenuActive();
                }),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: customWidth(size: 0.1),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Image.asset("Assets/icons/dots.png"),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

//Clipper for clipping top area from bottom
class UpDownClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double centerWidth = width / 2;
    double centerHeight = height / 2;
    Path path = Path();
    path.moveTo(0, height * 0.52);
    path.quadraticBezierTo(
        width * 0.02, height * 0.75, width * 0.35, height * 0.75);
    path.lineTo(width * 0.7, height * 0.75);
    path.quadraticBezierTo(width, height * 0.75, width, height);
    path.lineTo(width, 0);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
