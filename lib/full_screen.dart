import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class FullScreen extends StatefulWidget {
  final String url;
  const FullScreen({super.key, required this.url});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setwallpaper() async {
    try {
      int location = WallpaperManager.BOTH_SCREEN;
      var file = (await DefaultCacheManager().getSingleFile(widget.url));
      await WallpaperManager.setWallpaperFromFile(file.path, location);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Wallpaper set properly")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error while setting up wallpaper: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new))),
      body: Column(
        children: [
          Expanded(child: Image.network(widget.url)),
          GestureDetector(
            onTap: setwallpaper,
            child: const SizedBox(
              height: 60,
              width: double.infinity,
              child: Text("Set Wallpaper",textAlign: TextAlign.center,style: TextStyle(fontSize: 20),),
            ),
          )
        ],
      ),
    );
  }
}
