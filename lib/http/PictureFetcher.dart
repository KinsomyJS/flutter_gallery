import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_gallery/model/picture.dart';
import 'package:flutter_gallery/model/picture_resp.dart';
import 'package:http/http.dart' as http;

class PictureFetcher {
  final _baseUrl = "https://picsum.photos/v2/list";

  Future<List<Picture>> fetchPictures({
    @required int page,
  }) async {
    final response = await http.get(
      '$_baseUrl?page=$page&limit=10',
    );
    print('http code: ${response.statusCode}');
    if (response.statusCode == HttpStatus.ok) {
      print("reqsponse:");
      return PictureResp.fromJson(jsonDecode(response.body)).pictures;
    } else {
      return null;
    }
  }
}
