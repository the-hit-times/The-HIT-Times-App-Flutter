import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DisplayPost extends StatelessWidget {
  DisplayPost(
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
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(37, 45, 59, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          padding: EdgeInsets.all(10),
          width: double.maxFinite,
          child: Column(
            children: [
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  backgroundColor: Color.fromRGBO(37, 45, 59, 1),
                  color: Color.fromARGB(255, 156, 223, 239),
                  fontWeight: FontWeight.w600,
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
      expandedHeight: MediaQuery.of(context).size.height / 2,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        background: Image(
          image: CachedNetworkImageProvider(imgUrl),
          fit: BoxFit.cover,
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              backgroundColor: Color.fromRGBO(37, 45, 59, 1),
              color: Color.fromARGB(255, 4, 201, 245),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 3,
          ),
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
              padding: const EdgeInsets.all(1.0),
              child: Text(
                body,
                style: TextStyle(
                    color: Colors.white, fontSize: 22.0, fontFamily: "Cambo"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
