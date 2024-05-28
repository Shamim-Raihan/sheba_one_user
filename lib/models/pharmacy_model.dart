class PharmacyModel {
  String? id;
  String? pharmacyName;
  String? drugLicenseNo;
  String? ownerName;
  String? contactNo;
  String? latitude;
  String? longitude;
  String? distance;

  PharmacyModel(
      {this.id,
      this.pharmacyName,
      this.ownerName,
      this.contactNo,
      this.latitude,
      this.longitude,
      this.distance});

  PharmacyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    pharmacyName = json['pharmacy_name'].toString();
    drugLicenseNo = json['drug_license_no'].toString();
    ownerName = json['owner_name'].toString();
    contactNo = json['contact_no'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    distance = json['distance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pharmacy_name'] = pharmacyName;
    data['drug_license_no'] = drugLicenseNo;
    data['owner_name'] = ownerName;
    data['contact_no'] = contactNo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    return data;
  }
}
