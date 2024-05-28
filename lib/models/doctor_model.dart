class DoctorModel {
  String? id;
  String? name;
  String? gender;
  String? specialization;
  String? bmdcNo;
  String? contactNo;
  String? email;
  String? consultFee;
  String? homeConsultFee;
  String? audioConsultFee;
  String? videoConsultFee;
  String? chamber;
  String? city;
  String? specialOrgan;
  String? image;
  String? refferalCode;
  String? adminApproval;
  String? createdAt;
  String? updatedAt;
  String? imagePath;
  String? experience;
  String? patients;
  List<EducationModel>? edus;

  DoctorModel(
      {this.id,
      this.name,
      this.gender,
      this.specialization,
      this.bmdcNo,
      this.contactNo,
      this.email,
      this.consultFee,
      this.homeConsultFee,
      this.audioConsultFee,
      this.videoConsultFee,
      this.chamber,
      this.city,
      this.specialOrgan,
      this.image,
      this.refferalCode,
      this.adminApproval,
      this.createdAt,
      this.updatedAt,
      this.imagePath,
      this.experience,
      this.patients,
      this.edus});

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    gender = json['gender'];
    specialization = json['specialization'];
    bmdcNo = json['bmdc_no'];
    contactNo = json['contact_no'];
    email = json['email'];
    consultFee = json['consult_fee'];
    chamber = json['chamber'];
    city = json['city'];
    specialOrgan = json['special_organ'];
    image = json['image'];
    refferalCode = json['refferal_code'];
    adminApproval = json['admin_approval'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagePath = json['image_path'];
    experience = json['experience'].toString();
    audioConsultFee = json['audio_consult_fee'].toString() == 'null'
        ? '0'
        : json['audio_consult_fee'].toString();
    videoConsultFee = json['video_consult_fee'].toString() == 'null'
        ? '0'
        : json['video_consult_fee'].toString();
    homeConsultFee = json['home_consult_fee'].toString() == 'null'
        ? '0'
        : json['home_consult_fee'].toString();
    patients = json['patients'].toString();
    if (json['edus'] != null) {
      edus = <EducationModel>[];
      json['edus'].forEach((v) {
        edus!.add(EducationModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['gender'] = gender;
    data['specialization'] = specialization;
    data['bmdc_no'] = bmdcNo;
    data['contact_no'] = contactNo;
    data['email'] = email;
    data['consult_fee'] = consultFee;
    data['chamber'] = chamber;
    data['city'] = city;
    data['special_organ'] = specialOrgan;
    data['image'] = image;
    data['refferal_code'] = refferalCode;
    data['admin_approval'] = adminApproval;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_path'] = imagePath;
    data['experience'] = experience;
    data['audio_consult_fee'] = audioConsultFee;
    data['video_consult_fee'] = videoConsultFee;
    data['home_consult_fee'] = homeConsultFee;
    data['patients'] = patients;
    if (edus != null) {
      data['edus'] = edus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EducationModel {
  int? id;
  int? doctorInfoId;
  String? degree;
  String? institution;
  String? passingYear;
  String? createdAt;
  String? updatedAt;

  EducationModel(
      {this.id,
      this.doctorInfoId,
      this.degree,
      this.institution,
      this.passingYear,
      this.createdAt,
      this.updatedAt});

  EducationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorInfoId = json['doctor_info_id'];
    degree = json['degree'];
    institution = json['institution'];
    passingYear = json['passing_year'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_info_id'] = doctorInfoId;
    data['degree'] = degree;
    data['institution'] = institution;
    data['passing_year'] = passingYear;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
