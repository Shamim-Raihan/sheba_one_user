class DoctorSpecialityModel {
  String? id;
  String? specialization;
  String? imagePath;

  DoctorSpecialityModel({this.id, this.specialization, this.imagePath});

  DoctorSpecialityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    specialization = json['specialization'].toString();
    imagePath = json['image_path'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['specialization'] = specialization;
    data['image_path'] = imagePath;
    return data;
  }
}

class DoctorSubSpecialityModel {
  String? id;
  String? subSpecialization;
  String? imagePath;

  DoctorSubSpecialityModel({this.id, this.subSpecialization, this.imagePath});

  DoctorSubSpecialityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    subSpecialization = json['sub_specialization'].toString();
    imagePath = json['image_path'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sub_specialization'] = subSpecialization;
    data['image_path'] = imagePath;
    return data;
  }
}
