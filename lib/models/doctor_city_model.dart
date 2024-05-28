class CityModel {
  String? id;
  String? city;
  String? imagePath;

  CityModel({this.id, this.city, this.imagePath});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    city = json['city'];
    imagePath = json['image_path'].toString() == 'null'
        ? ''
        : json['image_path'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['image_path'] = imagePath;
    return data;
  }
}
