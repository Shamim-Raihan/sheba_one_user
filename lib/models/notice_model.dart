// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';

List<NoticeModel> noticeModelFromJson(String str) => List<NoticeModel>.from(json.decode(str).map((x) => NoticeModel.fromJson(x)));

String noticeModelToJson(List<NoticeModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoticeModel {
  NoticeModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.dateTime,
    required this.imagePath,
  });

  int id;
  String title;
  String body;
  String image;
  DateTime dateTime;
  String imagePath;

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    image: json["image"],
    dateTime: DateTime.parse(json["date_time"]),
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "image": image,
    "date_time": dateTime.toIso8601String(),
    "image_path": imagePath,
  };
}
