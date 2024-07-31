import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_hit_times_app/models/postmodel.dart';

class BookMarkService {
  static List<PostModel> localnews = [];

  Future<List<PostModel>> getLocalNews() async {
    final prefs = await SharedPreferences.getInstance();
    localnews = prefs
        .getStringList("news")!
        .map((e) => PostModel.fromJson(json.decode(e)))
        .toList();
    return localnews;
  }

  saveNews(PostModel data) async {
    getLocalNews();
    final prefs = await SharedPreferences.getInstance();
    localnews.add(data);
    final datalist = localnews!
        .map((item) => json.encode(PostModel(
                id: item.id,
                title: item.title,
                body: item.body,
                cImage: item.cImage,
                createdAt: item.createdAt,
                description: item.description,
                dropdown: item.dropdown,
                link: item.link,
                updatedAt: item.updatedAt)
            .toJson()))
        .toList();
    await prefs.setStringList('news', datalist);
  }

  deleteNews(PostModel data) async {
    getLocalNews();
    final prefs = await SharedPreferences.getInstance();
    localnews.removeWhere((item) => item.id == data.id);
    final datalist = localnews!
        .map((item) => json.encode(PostModel(
                id: item.id,
                title: item.title,
                body: item.body,
                cImage: item.cImage,
                createdAt: item.createdAt,
                description: item.description,
                dropdown: item.dropdown,
                link: item.link,
                updatedAt: item.updatedAt)
            .toJson()))
        .toList();
    await prefs.setStringList('news', datalist);
  }
}
