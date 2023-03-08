import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:the_hit_times_app/card_ui.dart';
import 'package:intl/intl.dart';
import 'package:the_hit_times_app/display.dart';
// import 'card_ui.dart';
import 'models/postmodel.dart';

//import 'package:zoomable_image/zoomable_image.dart';

class News extends StatefulWidget {
  @override
  NewsState createState() {
    return NewsState();
  }
}

class NewsState extends State<News> {
  final String url =
      "https://the-hit-times-admin-production.up.railway.app/api/posts";
  List data = List.empty();
  late PostList allPosts;

  Future<String> getSWData() async {
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});
    //print(allPosts.posts.length);
    setState(() {
      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      data = allPosts.posts;
    });
    print(allPosts.posts.length);
    print(data);
    for (var i = 0; i <= allPosts.posts.length; i++) {
      print(allPosts.posts[i].id);
    }
    //print(data.sort());
    return "Success";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        // child : DisplayBody(author: "Ayab", body: "bidu",date: "today",)
        child: RefreshIndicator(
          onRefresh: getSWData,
          child: data.isEmpty
              ? const Center(child: const CircularProgressIndicator())
              : data.length != 0
                  ? ListView.builder(
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      DisplayPost(
                                pIndex: index,
                                title: allPosts.posts[index].title,
                                body: allPosts.posts[index].body,
                                imgUrl: allPosts.posts[index].link,
                                description: allPosts.posts[index].description,
                                date: allPosts.posts[index].createdAt,
                                category:
                                    int.parse(allPosts.posts[index].dropdown),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ));
                          },
                          child: CusCard(
                              imgUrl: allPosts.posts[index].link,
                              title: allPosts.posts[index].title,
                              description: allPosts.posts[index].description,
                              body: allPosts.posts[index].body,
                              date: allPosts.posts[index].createdAt),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chrome_reader_mode,
                              color: Colors.grey, size: 60.0),
                          Text(
                            "No articles found",
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    ]);
  }
}
