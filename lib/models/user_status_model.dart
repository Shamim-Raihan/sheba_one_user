// To parse this JSON data, do
//
//     final userStatusModel = userStatusModelFromJson(jsonString);

import 'dart:convert';

UserStatusModel userStatusModelFromJson(String str) => UserStatusModel.fromJson(json.decode(str));

String userStatusModelToJson(UserStatusModel data) => json.encode(data.toJson());

class UserStatusModel {
  UserStatusModel({
    required this.status,
    required this.inactiveUser,
    required this.activeUser,
  });

  bool status;
  int inactiveUser;
  int activeUser;

  factory UserStatusModel.fromJson(Map<String, dynamic> json) => UserStatusModel(
    status: json["status"],
    inactiveUser: json["inactive_user"],
    activeUser: json["active_user"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "inactive_user": inactiveUser,
    "active_user": activeUser,
  };
}
