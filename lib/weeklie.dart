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
  final String url =
      "https://the-hit-times-admin-production.up.railway.app/api/posts";
  List data = List.empty();
  late PostList allPosts;
  int weekliesLength = 0;

  Future<String> getSWData() async {
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});

    setState(() {
      var resBody = json.decode(res.body);
      allPosts = PostList.fromJson(resBody);
      allPosts.posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      data = resBody;
      allPosts.posts.removeWhere((item) =>
          item.dropdown == '06' ||
          item.dropdown == '07' ||
          item.dropdown == '08');
      data = allPosts.posts;
      weekliesLength = allPosts.posts.length;
    });

    print("------------------------------------------");
    for (var i = 0; i <= 30; i++) {
      print(allPosts.posts[i].id.toString() +
          " -- " +
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
        child: data.isEmpty
            ? const Center(child: const CircularProgressIndicator())
            : weekliesLength != 0
                ? ListView.builder(
                    itemCount: weekliesLength == 0 ? 0 : weekliesLength,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => DisplayPost(
                              pIndex: index,
                              title: allPosts.posts[index].title,
                              body: allPosts.posts[index].body,
                              imgUrl: allPosts.posts[index].link,
                              date: allPosts.posts[index].createdAt,
                              category:
                                  int.parse(allPosts.posts[index].dropdown),
                              description: allPosts.posts[index].description,
                            ),
                          ));
                        },
                        child: CusCard(
                          imgUrl: allPosts.posts[index].link,
                          title: allPosts.posts[index].title,
                          description: allPosts.posts[index].description,
                          body: allPosts.posts[index].body,
                          date: allPosts.posts[index].createdAt,
                        ),
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
                          style: TextStyle(fontSize: 24.0, color: Colors.grey),
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
  final String url =
      "https://the-hit-times-admin-production.up.railway.app/api/posts";
  List data = List.empty();
  late PostList allPosts;
  int AppXLength = 0;

  Future<String> getSWData() async {
    List<nf.Notification> notes = await NotificationDatabase.instance.readAllNotifications();
    print("notes.length");
    print(notes.length);
    var res = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: {"Accept": "application/json"});

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
      data = allPosts.posts;
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
        child: data.isEmpty
            ? const Center(child: const CircularProgressIndicator())
            : AppXLength != 0
                ? ListView.builder(
                    itemCount: AppXLength == 0 ? 0 : AppXLength,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => DisplayPost(
                                pIndex: index,
                                title: allPosts.posts[index].title,
                                body: allPosts.posts[index].body,
                                imgUrl: allPosts.posts[index].link,
                                date: allPosts.posts[index].createdAt,
                                description: allPosts.posts[index].description,
                                category: 0),
                          ));
                        },
                        child: CusCard(
                          imgUrl: allPosts.posts[index].link,
                          title: allPosts.posts[index].title,
                          description: allPosts.posts[index].description,
                          body: allPosts.posts[index].body,
                          date: allPosts.posts[index].createdAt,
                        ),
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
                          style: TextStyle(fontSize: 24.0, color: Colors.grey),
                        ),
                      ],
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
  