import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/models/postmodel.dart';
import 'package:the_hit_times_app/news.dart';

class Weeklies extends StatefulWidget {
  @override
  _WeekliesState createState() => _WeekliesState();
}

class _WeekliesState extends State<Weeklies> {

  final String url = "http://thehittimes.herokuapp.com/posts";
  List data = List.empty();
  late PostList allPosts;
  int weekliesLength = 0;

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.parse(Uri.encodeFull(url)), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      data = resBody;
      allPosts.posts.removeWhere((item) =>
      item.dropdown == '06' ||
          item.dropdown == '07' ||
          item.dropdown == '08');
      weekliesLength = allPosts.posts.length;
    });


    print("------------------------------------------");
    for (var i = 0; i <= 30; i++) {
      print(allPosts.posts[i].id.toString() + " -- " +
          allPosts.posts[i].dropdown.toString());
    }

    print(data.length);
    print("------------------------------------------");
    print(weekliesLength);
    print("------------------------------------------");
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
        child: data == null
            ? const Center(child: const CircularProgressIndicator())
            : weekliesLength != 0
            ? new ListView.builder(
          itemCount: weekliesLength == 0 ? 0 : weekliesLength,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new DisplayPost(
                    pIndex: index,
                    title: allPosts.posts[index].title,
                    body: allPosts.posts[index].body,
                    imgUrl: allPosts.posts[index].link,
                    date: allPosts.posts[index].createdAt,
                    category: int.parse(allPosts.posts[index].dropdown),
                  ),
                ));
              },
              child: CusCard(
                            imgUrl: data[data.length - index- 1]['link'],
                            title: data[data.length - index- 1]['title'],
                            // author: allPosts.posts[index].link,
                            // date: allPosts.posts[index].title,
                            // body: url,
                          ),
            );
          },
        )
            : new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(Icons.chrome_reader_mode,
                  color: Colors.grey, size: 60.0),
              new Text(
                "No articles found",
                style:
                new TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class AppX extends StatefulWidget {
  @override
  _AppXState createState() => _AppXState();
}

class _AppXState extends State<AppX> {
  final String url = "http://thehittimes.herokuapp.com/posts";
  List data = List.empty();
  late PostList allPosts;
  int AppXLength = 0;


  Future<String> getSWData() async {
    var res = await http
        .get(Uri.parse(Uri.encodeFull(url)), headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      data = resBody;
      allPosts.posts.removeWhere((item) =>
      item.dropdown == '05' ||
          item.dropdown == '04' ||
          item.dropdown == '03' ||
          item.dropdown == '02' ||
          item.dropdown == '01' ||
          item.dropdown == '00');
      AppXLength = allPosts.posts.length;
    });

    print("------------------------------------------");
    //print(weeklies.length);
    print("------------------------------------------");
    print(allPosts.posts.length);
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
        child: data == null
            ? const Center(child: const CircularProgressIndicator())
            : AppXLength != 0
            ? new ListView.builder(
          itemCount: AppXLength == 0 ? 0 : AppXLength,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new DisplayPost(
                    pIndex: index,
                    title: allPosts.posts[index].title,
                    body: allPosts.posts[index].body,
                    imgUrl: allPosts.posts[index].link,
                    date: allPosts.posts[index].createdAt,
                    category: 0
                  ),
                ));
              },
              child: CusCard(
                            imgUrl: data[data.length - index- 1]['link'],
                            title: data[data.length - index- 1]['title'],
                            // author: allPosts.posts[index].link,
                            // date: allPosts.posts[index].title,
                            // body: url,
                          ),
            );
          },
        )
            : new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Icon(Icons.chrome_reader_mode,
                  color: Colors.grey, size: 60.0),
              new Text(
                "No articles found",
                style:
                new TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}