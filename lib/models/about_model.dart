// To parse this JSON data, do
//
//     final aboutModel = aboutModelFromJson(jsonString);

import 'dart:convert';

AboutModel aboutModelFromJson(String str) => AboutModel.fromJson(json.decode(str));

String aboutModelToJson(AboutModel data) => json.encode(data.toJson());

class AboutModel {
  AboutModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.imagePath,
  });

  int id;
  String title;
  String body;
  String image;
  String imagePath;

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    image: json["image"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "image": image,
    "image_path": imagePath,
  };
}
