import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// Custom Http Class with cache implementation.
class CachedHttp {

  static const int NO_CACHE = -400;
  static const int CACHED_RESPONSE = -200;

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

  /// It is used to get a CachedResponse. <br>
  /// Returns a <b>CachedResponse</b>
  static Future<CachedResponse> get(String url, {required Map<String, String> headers}) async {

    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        DefaultCacheManager().putFile(url,response.bodyBytes);
      }
      return CachedResponse(
          responseStatus: response.statusCode,
          responseBody: jsonDecode(response.body),
          error: false,
          errorMessage: null
      );
    } catch (e) {
      debugPrint("Loading Failed: $url");
      debugPrint("Loading Cache: $url");
    }

    // Try to load from cache for specific Url.
    var file = await DefaultCacheManager().getSingleFile(url);
    if (await file.exists()) {
      return CachedResponse(
          responseStatus: CACHED_RESPONSE,
          responseBody: jsonDecode(await file.readAsString()),
          error: false,
          errorMessage: null
      );
    }

    // Return an empty response if there is no cache available.
    return CachedResponse(
        responseStatus: NO_CACHE,
        responseBody: null,
        error: true,
        errorMessage: "No cache available"
    );
  }

}

/// CachedResponse is a custom class which provides as well as additional information
/// such as if there is a error, loaded from cache or from the server.
class CachedResponse {
  int responseStatus;
  dynamic responseBody;
  bool error;
  String? errorMessage;

  CachedResponse({
    required this.responseStatus,
    required this.responseBody,
    required this.error,
    required this.errorMessage
  });
}
