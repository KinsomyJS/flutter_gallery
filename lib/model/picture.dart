import 'package:json_annotation/json_annotation.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  String id; //picture id
  String author; //picture author
  int width;
  int height;
  String url; //unsplash url
  String download_url; //real pic url

  Picture(this.id, this.author, this.width, this.height, this.url,
      this.download_url);

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
