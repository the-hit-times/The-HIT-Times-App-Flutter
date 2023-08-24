import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:reading_time/reading_time.dart';
import 'package:the_hit_times_app/models/postmodel.dart';
import 'package:the_hit_times_app/news.dart';

class CusCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String body;
  final String link;
  final String dropdown;
  final String createdAt;
  final String updatedAt;
  final String cImage;
  final bool bookmarked;
  final ValueChanged<PostModel> add;
  final ValueChanged<PostModel> delete;

  CusCard({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    required this.link,
    required this.dropdown,
    required this.createdAt,
    required this.updatedAt,
    required this.cImage,
    required this.bookmarked,
    required this.add,
    required this.delete,
  });

  void handelBookmark() {
    final PostModel post = PostModel(
        id: id,
        title: title,
        description: description,
        body: body,
        link: link,
        dropdown: dropdown,
        createdAt: createdAt,
        updatedAt: updatedAt,
        cImage: cImage);
    bookmarked ? delete(post) : add(post);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.all(7),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: CachedNetworkImage(
                  imageUrl: link,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black12,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white,),
                ),
              ),
            )),
            Expanded(
                child: Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                color: Colors.white,
                                icon: bookmarked
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(Icons.favorite_outline),
                                onPressed: () {
                                  handelBookmark();
                                },
                              ),
                            )
                          ],
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white54,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        body.isNotEmpty ? Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            body,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ): Container(),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            body.isNotEmpty ? readingTime(body).msg : "Nothing to read",
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )))
          ],
        ));
  }
}

class NotiCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String description;
  final String body;
  final String date;
  final VoidCallback onClear;

  NotiCard(
      {required this.imgUrl,
      required this.title,
      required this.description,
      required this.body,
      required this.date,
      required this.onClear
      });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 90.0,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black12,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white,),
                ),
              ),
            )),
            Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white54,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            '${date.substring(0, 10)}',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ))),
                    IconButton(
                      onPressed: onClear,
                      icon: Icon(Icons.clear, color: Colors.white,),
                    )
          ],
        ));
  }
}
