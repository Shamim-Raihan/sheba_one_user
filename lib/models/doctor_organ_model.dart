class OrganModel {
  String? id;
  String? specialOrgan;
  String? imagePath;

  OrganModel({this.id, this.specialOrgan, this.imagePath});

  OrganModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    specialOrgan = json['special_organ'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['special_organ'] = specialOrgan;
    data['image_path'] = imagePath;
    return data;
  }
}
