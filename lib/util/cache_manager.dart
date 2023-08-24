import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class Http {
  static Future<http.Response> get(String url, {required Map<String, String> headers}) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      return http.Response(await file.readAsString(), 200);
    } else {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        DefaultCacheManager().putFile(url,response.bodyBytes);
      }
      return response;
    }
  }

  static Future<String> getBody(String url, {required Map<String, String> headers}) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        DefaultCacheManager().putFile(url,response.bodyBytes);
      }
      return response.body;
    }
  }
}
