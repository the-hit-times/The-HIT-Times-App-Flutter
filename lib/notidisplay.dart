import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:the_hit_times_app/display.dart';
import 'package:the_hit_times_app/globals.dart';
import 'package:the_hit_times_app/models/postmodel.dart';
import 'package:the_hit_times_app/util/cache_manager.dart';

class Notidisplay extends StatelessWidget {
  Notidisplay(
      {required this.pIndex,
      required this.body,
      required this.title,
      required this.description,
      required this.imgUrl,
      required this.date,
      required this.category});

  final int pIndex;
  final String body;
  final String title;
  final String imgUrl;
  final String date;
  final String description;
  final int category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarBldr(
            imgUrl: imgUrl,
            title: title,
            description: description,
          ),
          SliverListBldr(
              body: body, title: title, description: description, date: date)
        ],
      ),
    );
  }
}

class SliverAppBarBldr extends StatelessWidget {
  const SliverAppBarBldr(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.description});

  final String imgUrl;
  final String description;
  final String title;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return SliverAppBar(
      toolbarHeight: 100,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(37, 45, 59, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 64, 64, 64),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: Offset(0, -12))
              ]),
          padding: EdgeInsets.all(10),
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      height: 1.5,
                      color: Color.fromARGB(255, 156, 223, 239),
                      backgroundColor: Color.fromRGBO(37, 45, 59, 1),
                    ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      stretch: true,
      expandedHeight: MediaQuery.of(context).size.height / 1.5,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        background: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return FullScreen(imgUrl: imgUrl);
            }));
          },
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.black12,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SliverListBldr extends StatelessWidget {
  const SliverListBldr(
      {Key? key,
      required this.body,
      required this.title,
      required this.description,
      required this.date})
      : super(key: key);

  final String body;
  final String title;
  final String description;
  final String date;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Text(
          //   title,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 20.0,
          //     backgroundColor: Color.fromRGBO(37, 45, 59, 1),
          //     color: Color.fromARGB(255, 4, 201, 245),
          //     fontWeight: FontWeight.w600,
          //   ),
          //   maxLines: 3,
          // ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date))}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: 12.0, right: 12.0, bottom: 12.0, top: 12.0),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                body,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    height: 1.5,
                    color: Colors.white,
                    fontSize: 15.0,
                    fontFamily: "Cambo"),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  const FullScreen({
    required this.imgUrl,
  });

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'image',
            child: Image.network(
              imgUrl,
              fit: BoxFit.fill,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class NotificationDisplayWeb extends StatefulWidget {
  final String postId;

  const NotificationDisplayWeb({Key? key, required this.postId})
      : super(key: key);

  @override
  _NotificationDisplayWebState createState() => _NotificationDisplayWebState();
}

class _NotificationDisplayWebState extends State<NotificationDisplayWeb> {
  late PostModel post;
  bool isLoading = true;
  bool failedLoading = false;

  // load timeline from the database
  void _loadPost() async {
    String url = "${Constants.BASE_URL}/post/${widget.postId}";
    var response =
        await CachedHttp.get(url, headers: {"Accept": "application/json"});

    if (response.error) {
      setState(() {
        isLoading = false;
        failedLoading = true;
      });
    }

    var data = response.responseBody;

    if (data['data'] == null) {
      setState(() {
        isLoading = false;
        failedLoading = true;
      });
    }

    setState(() {
      post = PostModel.fromJson(data['data']);
      isLoading = false;
    });
  }

  @override
  initState() {
    super.initState();
    _loadPost();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
        appBar: AppBar(
          title: Text("The Hit Times"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(child: CircularProgressIndicator()))
        : failedLoading
            ? Scaffold(
                appBar: AppBar(
                  title: Text("The Hit Times"),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Failed to load post",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      FilledButton.icon(
                        icon: Icon(Icons.refresh),
                        onPressed: () {

                          setState(() {
                            isLoading = true;
                            failedLoading = false;
                          });

                          _loadPost();
                        }, label: Text("Retry"),)
                    ],
                  ),
                ))
            : DisplayPost(
                pIndex: 0,
                body: post.body,
                title: post.title,
                description: post.description,
                imgUrl: post.link,
                date: post.createdAt,
                htmlBody: post.htmlBody,
                category: int.parse(post.dropdown),
              );
  }
}
