import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:the_hit_times_app/card_ui.dart';
import 'package:the_hit_times_app/display.dart';
import 'package:the_hit_times_app/globals.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

import 'bookmark_service/bookmark_service.dart';
// import 'card_ui.dart';
import 'models/postmodel.dart';

//import 'package:zoomable_image/zoomable_image.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  NewsState createState() {
    return NewsState();
  }
}

class NewsState extends State<News> {
  List<PostModel> items = [];
  List<PostModel> localnews = BookMarkService.localnews;
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
    getLocalNews();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print("Bottom");

        getSWData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(News oldWidget) {
    super.didUpdateWidget(oldWidget);
    getLocalNews();
  }

  Future<String> getSWData() async {
    if (!hasmore) return "";
    if (loading) return "Loading";
    loading = true;
    final String url = "${Constants.BASE_URL}/posts?limit=$limit&page=$page";
    print("Fetching... $url");
    var res =
        await CachedHttp.getBody(url, headers: {"Accept": "application/json"});

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('No Internet Connection!'),
      ));
    }

    setState(() {
      page = page + 1;

      var resBody = json.decode(res);
      allPosts = PostList.fromJson(resBody);

      // Clean up HTML tags in the body of each post
      for (var post in allPosts.posts) {
        post.body = _removeHtmlTags(post.body);
      }

      if (resBody.length < limit) {
        hasmore = false;
      }
      items.addAll(allPosts.posts);
      loading = false;
    });
    return "Success";
  }

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, dotAll: true);
    return htmlString.replaceAll(exp, '').trim();
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text('News is added to favourite'),
    ));
  }

  deletenews(PostModel data) {
    BookMarkService().deleteNews(data);
    setState(() {
      getLocalNews();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.green,
      content: Text('News is removed from favourite'),
    ));
  }

  bool checkAdded(PostModel data) {
    final ispresent = localnews.any((item) => item.id == data.id);
    return ispresent;
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
    getLocalNews();
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
                ? !loading
                    ? const Center(
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
                      )
                    : const Center(child: CircularProgressIndicator())
                : ListView.builder(
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
                                htmlBody: items[index].htmlBody,
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
                            link: items[index].link,
                            title: items[index].title,
                            description: items[index].description,
                            body: items[index].body,
                            createdAt: items[index].createdAt,
                            cImage: items[index].cImage,
                            dropdown: items[index].dropdown,
                            id: items[index].id,
                            updatedAt: items[index].updatedAt,
                            bookmarked: checkAdded(items[index]),
                            add: addnews,
                            delete: deletenews,
                          ),
                        );
                      } else {
                        return hasmore
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : Container();
                      }
                    },
                  )),
      ),
    ]);
  }
}
