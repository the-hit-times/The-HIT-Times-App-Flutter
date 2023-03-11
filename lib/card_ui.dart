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
                child: Image(
                  image: CachedNetworkImageProvider(link),
                  fit: BoxFit.cover,
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
                                    ? const Icon(Icons.bookmark)
                                    : const Icon(Icons.bookmark_add_outlined),
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
                        Container(
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
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            '${readingTime(body).msg}',
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

// class backgroundImage extends StatelessWidget {
//   final String imgUrl;

//   backgroundImage(this.imgUrl);

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//             image: CachedNetworkImageProvider(imgUrl),
//             /*colorFilter: ColorFilter.mode(
//           Colors.black.withOpacity(0.6),
//           BlendMode.luminosity
//       ),*/
//             fit: BoxFit.cover),
//       ),
//     );
//   }
// }

// class topContent extends StatelessWidget {
//   final String title;

//   topContent(this.title);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 119.0,
//       /*color: Colors.black,*/
//       child: Container(
//         color: Colors.black38,
//         /*decoration: ,*/
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                   color: Color(0xFF0FB9B1),
//                   border: Border.all(width: 2.0, color: Color(0xFF0FB9B1)),
//                   borderRadius: BorderRadius.all(Radius.circular(5.0))),
//               margin: EdgeInsets.only(left: 30.0, bottom: 2.0),
//               height: 5.0,
//               width: 100.0,
//             ),
//             Flexible(
//               fit: FlexFit.tight,
//               flex: 1,
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   margin: EdgeInsets.only(left: 10.0, bottom: 2.0),
//                   child: title.length < 17
//                       ? Text(
//                           title,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 29.0,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "Exo",
//                           ),
//                           maxLines: 1,
//                         )
//                       : Text(
//                           title,
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 23.0,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: "Exo",
//                               textBaseline: TextBaseline.ideographic),
//                           maxLines: 2,
//                         ),
//                 ),
//               ),
//             ),
//             Container(
//               color: Colors.black,
//               height: 40.0,
//               width: double.infinity,
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(10.0),
//                     child: Text(
//                       "Read More...",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 15.0,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }