import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// Custom Http Class with cache implementation.
class Http {

  /// Returns a Http.Body response based on availability
  /// if a GET request fails, it try to returns from cache.
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

    // Try to load from cache for specific Url.
    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      return await file.readAsString();
    }

    // Return an empty response if there is no cache available.
    return "";
  }
}
