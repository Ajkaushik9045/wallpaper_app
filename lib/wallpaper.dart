import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int pages = 1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    fetchdata();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadmore();
      }
    });
  }
  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  fetchdata() async {
    await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=50"),
      headers: {
        'Authorization':
            'm61HvB0dYhJvL6c4cfxBfIhKetnoBjdYzEWVKc76rXOBaTq8cnUKHVOH'
      },
    ).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images = result['photos'];
      });
    });
  }

  loadmore() async {
    setState(() {
      pages += pages;
    });
    await http.get(
      Uri.parse("https://api.pexels.com/v1/curated?per_page=50&pages$pages"),
      headers: {
        'Authorization':
            'm61HvB0dYhJvL6c4cfxBfIhKetnoBjdYzEWVKc76rXOBaTq8cnUKHVOH'
      },
    ).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallpapers")),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 2 / 4),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullScreen(
                            url: images[index]['src']['large2x'],
                          )));
            },
            child: Container(
              color: Colors.white,
              child: Image.network(
                images[index]['src']['tiny'],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        itemCount: images.length,
      ),
    );
  }
}
