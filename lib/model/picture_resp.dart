import 'package:flutter_gallery/model/picture.dart';
import 'package:json_annotation/json_annotation.dart';

part 'picture_resp.g.dart';

@JsonSerializable()
class PictureResp {
  List<Picture> pictures; //real pic url

  PictureResp(this.pictures);

  factory PictureResp.fromJson(List<dynamic> json) =>
      _$PictureRespFromJson(json);
}
