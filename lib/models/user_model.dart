// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? userId;
  String? name;
  String? email;
  String? mobile;
  String? address;
  String? district;
  String? area;
  String? createdAt;
  String? updatedAt;
  String? referCode;
  String? wallet;
  String? deviceToken;
  String? usedCoupon;

  UserModel(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.mobile,
      this.address,
      this.district,
      this.area,
      this.createdAt,
      this.updatedAt,
      this.referCode,
      this.wallet,
      this.deviceToken,
      this.usedCoupon});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'].toString(),
        userId: json['userId'].toString(),
        name: json['name'].toString() == 'null' ? " - " : json['name'],
        email: json['email'].toString() == 'null' ? "" : json['email'],
        mobile: json['mobile'],
        address: json['address'].toString() == 'null' ? "" : json['address'],
        district: json['district'].toString() == 'null' ? "" : json['district'],
        area: json['area'].toString() == 'null' ? "" : json['area'],
        createdAt: json['created_at'].toString(),
        updatedAt: json['updated_at'].toString(),
        referCode: json['refer_code'].toString(),
        wallet: json['wallet'].toString(),
        deviceToken: json['device_token'].toString() == 'null'
            ? ''
            : json['device_token'].toString(),
        usedCoupon: json['used_coupon'].toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'address': address,
        'district': district,
        'area': area,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'refer_code': referCode,
        'wallet': wallet,
        'device_token': deviceToken,
        'used_coupon': usedCoupon,
      };
}
