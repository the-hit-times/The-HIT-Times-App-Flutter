import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class Http {

  @Deprecated('Use getBody instead. Characters are lost when using this method')
  /// TODO: Fix characters being lost when using this method
  static Future<http.Response> get(String url, {required Map<String, String> headers}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        DefaultCacheManager().putFile(url,response.bodyBytes);
      }
      return response;
    } catch (e) {
      debugPrint("Loading Failed: $url");
      debugPrint("Loading Cache: $url");
    }

    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      return http.Response(await file.readAsString(), 200);
    }

    return http.Response("", 404);
  }

  static Future<String> getBody(String url, {required Map<String, String> headers}) async {

    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        DefaultCacheManager().putFile(url,response.bodyBytes);
      }
      return response.body;
    } catch (e) {
      debugPrint("Loading Failed: $url");
      debugPrint("Loading Cache: $url");
    }

    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      return await file.readAsString();
    }

    return "";
  }
}
