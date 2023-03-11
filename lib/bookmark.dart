import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_hit_times_app/bookmark_service/bookmark_service.dart';
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/display.dart';
import 'package:the_hit_times_app/models/postmodel.dart';
import 'package:http/http.dart' as http;
import 'package:the_hit_times_app/news.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  List<PostModel> localnews = [];

  @override
  void initState() {
    super.initState();
    getLocalNews();
  }

  getLocalNews() async {
    localnews = await BookMarkService().getLocalNews();
    setState(() {});
  }

  addnews(PostModel data) {
    BookMarkService().saveNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: const Text('News is added to bookmark'),
    ));
  }

  deletenews(PostModel data) {
    BookMarkService().deleteNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: const Text('News is removed from bookmark'),
    ));
  }

  bool checkAdded(PostModel data) {
    final ispresent = localnews.any((item) => item.id == data.id);
    return ispresent;
  }

  Future<String> handelRefresh() async {
    getLocalNews();
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BookMark'),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: RefreshIndicator(
          onRefresh: handelRefresh,
          child: !localnews.isEmpty
              ? ListView.builder(
                  itemCount: localnews.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DisplayPost(
                            pIndex: index,
                            title: localnews[index].title,
                            body: localnews[index].body,
                            imgUrl: localnews[index].link,
                            description: localnews[index].description,
                            date: localnews[index].createdAt,
                            category: int.parse(localnews[index].dropdown),
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                        link: localnews[index].link,
                        title: localnews[index].title,
                        description: localnews[index].description,
                        body: localnews[index].body,
                        createdAt: localnews[index].createdAt,
                        cImage: localnews[index].cImage,
                        dropdown: localnews[index].dropdown,
                        id: localnews[index].id,
                        updatedAt: localnews[index].updatedAt,
                        bookmarked: checkAdded(localnews[index]),
                        add: addnews,
                        delete: deletenews,
                      ),
                    );
                  })
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chrome_reader_mode,
                          color: Colors.grey, size: 60.0),
                      Text(
                        "No Bookmarked News found",
                        style: TextStyle(fontSize: 24.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
