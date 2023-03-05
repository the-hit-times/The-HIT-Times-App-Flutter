import 'dart:convert';
import 'dart:core';

class PostModel {
  String id;
  String title;
  String description;
  String body;
  String link;
  String dropdown;
  String createdAt;
  String updatedAt;
  String cImage;

  PostModel(
      {required this.id,
       required this.title,
       required this.description,
        required this.body,
        required this.link,
        required this.dropdown,
        required this.createdAt,
        required this.updatedAt,
        required this.cImage});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
        id : json['_id'],
        title : json['title'],
        description : json['description'],
        body : json['body'],
        link : json['link'],
        dropdown : json['dropdown'],
        createdAt : json['createdAt'],
        updatedAt : json['updatedAt'],
        cImage : json['c_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['body'] = this.body;
    data['link'] = this.link;
    data['dropdown'] = this.dropdown;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['c_image'] = this.cImage;
    return data;
  }
}

class PostList {
  final List<PostModel> posts;

  PostList({
   required this.posts,
  });

  factory PostList.fromJson(List<dynamic> parsedJson){
    List<PostModel> posts = <PostModel>[];
    posts = parsedJson.map((i)=>PostModel.fromJson(i)).toList();

    return PostList(
      posts: posts,
    );
  }
  /*List<PostModel> allPostsFromJson(String str){
    final jsonData = json.decode(str);
    return List<PostModel>.from(jsonData.map((x) => PostModel.fromJson(x)));
  } */
}
