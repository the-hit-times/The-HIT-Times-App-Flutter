import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/database_helper.dart';
import 'package:the_hit_times_app/models/postmodel.dart';
import 'package:the_hit_times_app/news.dart';
import 'package:the_hit_times_app/display.dart';
import 'package:the_hit_times_app/models/notification.dart' as nf;

class Weeklies extends StatefulWidget {
  @override
  _WeekliesState createState() => _WeekliesState();
}

class _WeekliesState extends State<Weeklies> {
  List<PostModel> items = [];
  int limit = 15;
  int page = 1;
  bool hasmore = true;
  bool loading = false;
  late PostList allPosts;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getSWData();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print("Bottom");

        this.getSWData();
      }
    });
  }

  Future<String> getSWData() async {
    if (!hasmore) return "";
    if (loading) return "Loading";
    loading = true;
    final String url =
        "https://the-hit-times-admin-production.up.railway.app/api/posts/weeklies?limit=$limit&page=$page";
    print("Fetching... $url");
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});
    setState(() {
      page = page + 1;

      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.map((e) => print(e.body));
      if (resBody.length < limit) {
        hasmore = false;
      }
      items.addAll(allPosts.posts);
      loading = false;
    });
    return "Success";
  }

  Future<String> handelRefresh() async {
    setState(() {
      items = [];
      limit = 15;
      page = 1;
      hasmore = true;
      loading = false;
    });
    getSWData();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        // child : DisplayBody(author: "Ayab", body: "bidu",date: "today",)
        child: RefreshIndicator(
          onRefresh: handelRefresh,
          child: items.isEmpty
              ? const Center(child: const CircularProgressIndicator())
              : items.length != 0
                  ? ListView.builder(
                      itemCount: items.length + 1,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < items.length) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DisplayPost(
                                  pIndex: index,
                                  title: items[index].title,
                                  body: items[index].body,
                                  imgUrl: items[index].link,
                                  description: items[index].description,
                                  date: items[index].createdAt,
                                  category: int.parse(items[index].dropdown),
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
                                imgUrl: items[index].link,
                                title: items[index].title,
                                description: items[index].description,
                                body: items[index].body,
                                date: items[index].createdAt),
                          );
                        } else {
                          return hasmore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                              : Container();
                        }
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

class AppX extends StatefulWidget {
  @override
  _AppXState createState() => _AppXState();
}

class _AppXState extends State<AppX> {
  List<PostModel> items = [];
  int limit = 15;
  int page = 1;
  bool hasmore = true;
  bool loading = false;
  late PostList allPosts;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getSWData();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print("Bottom");

        this.getSWData();
      }
    });
  }

  Future<String> getSWData() async {
    if (!hasmore) return "";
    if (loading) return "Loading";
    loading = true;
    final String url =
        "https://the-hit-times-admin-production.up.railway.app/api/posts/appx?limit=$limit&page=$page";
    print("Fetching... $url");
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});
    setState(() {
      page = page + 1;

      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.map((e) => print(e.body));
      if (resBody.length < limit) {
        hasmore = false;
      }
      items.addAll(allPosts.posts);
      loading = false;
    });
    return "Success";
  }

  Future<String> handelRefresh() async {
    setState(() {
      items = [];
      limit = 15;
      page = 1;
      hasmore = true;
      loading = false;
    });
    getSWData();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        // child : DisplayBody(author: "Ayab", body: "bidu",date: "today",)
        child: RefreshIndicator(
          onRefresh: handelRefresh,
          child: items.isEmpty
              ? const Center(child: const CircularProgressIndicator())
              : items.length != 0
                  ? ListView.builder(
                      itemCount: items.length + 1,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < items.length) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DisplayPost(
                                  pIndex: index,
                                  title: items[index].title,
                                  body: items[index].body,
                                  imgUrl: items[index].link,
                                  description: items[index].description,
                                  date: items[index].createdAt,
                                  category: int.parse(items[index].dropdown),
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
                                imgUrl: items[index].link,
                                title: items[index].title,
                                description: items[index].description,
                                body: items[index].body,
                                date: items[index].createdAt),
                          );
                        } else {
                          return hasmore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                              : Container();
                        }
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

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('The HIT Times'),
    //     centerTitle: true,
    //     iconTheme: IconThemeData(
    //       color: Colors.white, //change your color here
    //     ),
    //   ),
    //   body: Stack(
    //     children: <Widget>[
    //       Align(
    //         alignment: Alignment.topCenter,
    //         child: Padding(
    //           padding: EdgeInsets.all(10.0),
    //           child: Container(
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.redAccent,
    //             child: Text(
    //               'Notifications',
    //               style: TextStyle(
    //                 fontFamily: 'Exo',
    //                 color: Colors.white,
    //                 fontSize: 25.0
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //       ),

    //       Align(
    //         alignment: Alignment.center,
    //         child: Padding(
    //           padding: const EdgeInsets.fromLTRB(0.0,30.5,0.0,0.5),
    //           child: Container(
    //             //height: MediaQuery.of(context).size.height,
    //             child: Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   Align(
    //                       alignment: Alignment.center,
    //                       child: Text(, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 22.0, fontFamily: "Anson"),)
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.fromLTRB(0.0,12.0,0.0,12.0),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: <Widget>[
    //                         Flexible(child: Text("Notification will be displayed here", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0, fontFamily: "Cambo"),), flex: 3,),
    //                         Flexible(
    //                           flex: 1,
    //                           child: Container(
    //                               height: 80.0,
    //                               width: 80.0,
    //                               child: Image.asset("assets/images/notifications.jpg", fit: BoxFit.cover,)
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: <Widget>[
    //                           Text('', style: TextStyle(fontSize: 18.0),),
    //                           Text("" , style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w500),)
    //                         ],
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  