import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reading_time/reading_time.dart';
import 'package:the_hit_times_app/models/postmodel.dart';

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

  const CusCard({
    super.key,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 6.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: link,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: bookmarked
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_outline),
                        onPressed: handelBookmark,
                      ),
                    ],
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (body.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        body,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      body.isNotEmpty
                          ? readingTime(body).msg
                          : "Nothing to read",
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotiCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String description;
  final String body;
  final String date;
  final VoidCallback onClear;

  const NotiCard(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.description,
      required this.body,
      required this.date,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        margin: const EdgeInsets.all(5.0),
        height: 90.0,
        decoration: const BoxDecoration(
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
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
            Expanded(
                flex: 2,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.white54,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            date.substring(0, 10),
                            style: const TextStyle(
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
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            )
          ],
        ));
  }
}
