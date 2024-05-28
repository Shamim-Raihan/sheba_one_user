import 'dart:convert';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel {
  CountryModel({
    required this.id,
    required this.countryName,
  });

  int id;
  String countryName;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    id: json["id"],
    countryName: json["country_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_name": countryName,
  };
}
