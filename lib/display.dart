import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class DisplayPost extends StatelessWidget {
  DisplayPost(
      {required this.pIndex,
      required this.body,
      required this.title,
      required this.description,
      required this.imgUrl,
      required this.date,
      required this.category,
      required this.htmlBody});

  final int pIndex;
  final String body;
  final String? htmlBody;
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
              body: body, htmlBody: htmlBody, title: title, description: description, date: date)
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
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(height: 1.5, 
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
          child : Image(
          image: CachedNetworkImageProvider(imgUrl),
          fit: BoxFit.cover,
        ),
        ),
      ),
    );
  }
}

class FullScreen extends StatelessWidget {
  const FullScreen(
      {
      required this.imgUrl,});

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

class SliverListBldr extends StatelessWidget {
  const SliverListBldr(
      {Key? key,
      required this.body,
      required this.title,
      required this.description,
      required this.date,
      required this.htmlBody
      })
      : super(key: key);

  final String body;
  final String title;
  final String description;
  final String date;
  final String? htmlBody;


  @override
  Widget build(BuildContext context) {

    Widget getValidContent() {
      if ( htmlBody != null && htmlBody != "") {
        return Html(
          data: htmlBody!,
          style: {
            // This sets the color of the text to white to all the elements
            // eg; p, a, div, etc.
            // just like a css selector.
            "*" : Style(
              color: Colors.white,
              fontSize: const FontSize(15.0),
              fontFamily: "Cambo",
            )
          },
        );

      }
      return Text(
        body,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(height: 1.5, color: Colors.white,
            fontSize: 15.0,
            fontFamily: "Cambo"),
      );
    }

    return SliverToBoxAdapter(
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
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
              padding: const EdgeInsets.all(5.0),
              child: getValidContent(),
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