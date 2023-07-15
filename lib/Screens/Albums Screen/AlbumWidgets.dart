import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../Components/ScreenBasicElements.dart';
import '../../Provider/AlbumProvider.dart';
import 'AlbumSongs Screen/AlbumSongs.dart';

class SongsAlbumWidget extends Column {
  BuildContext context;
  AlbumProvider albumProvider;
  int index;
  SongsAlbumWidget(
      {required this.context, required this.albumProvider, required this.index})
      : super(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return AlbumSongsScreen(
                      album: albumProvider.listAlbums[index].album,
                    );
                  },
                ));
              },
              //Main container
              child: Container(
                margin: EdgeInsets.only(top: customClientHeight(size: 0.0)),
                width: customWidth(size: 0.42),

                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(2, 2), blurRadius: 4)
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                // folder icon
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset("Assets/icons/folder.png"),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 2),
                  //text showing Album name
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
                //Text showing number of items in the album
                Text(
                  "${albumProvider.listAlbums[index].numOfSongs} items",
                  style: TextStyle(
                      fontSize: customFontSize(size: 0.026),
                      color: const Color.fromARGB(255, 131, 128, 128)),
                )
              ],
            )
          ],
        );
}
