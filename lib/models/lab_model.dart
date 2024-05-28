class LabTestCategoryModel {
  String? id;
  String? name;
  String? maxOffer;

  LabTestCategoryModel({this.id, this.name, this.maxOffer});

  LabTestCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    maxOffer = json['max_offer'].toString() == 'null'
        ? '0'
        : json['max_offer'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['max_offer'] = maxOffer;
    return data;
  }
}

class LabTestModel {
  String? id;
  String? testCategory;
  String? testName;
  String? testPrice;
  String? offerPrice;
  String? discountPercentage;
  String? about;
  String? preparation;
  String? result;

  LabTestModel(
      {this.id,
      this.testCategory,
      this.testName,
      this.testPrice,
      this.offerPrice,
      this.discountPercentage,
      this.about,
      this.preparation,
      this.result});

  LabTestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    testCategory = json['test_category'].toString();
    testName = json['test_name'];
    testPrice = json['test_price'].toString();
    offerPrice = json['offer_price'].toString();
    discountPercentage = json['discount_percentage'].toString();
    about = json['about'];
    preparation = json['preparation'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['test_category'] = testCategory;
    data['test_name'] = testName;
    data['test_price'] = testPrice;
    data['offer_price'] = offerPrice;
    data['discount_percentage'] = discountPercentage;
    data['about'] = about;
    data['preparation'] = preparation;
    data['result'] = result;
    return data;
  }
}

class LabModel {
  String? id;
  String? labName;
  String? drugLicenseNo;
  String? ownerName;
  String? contactNo;
  String? address;
  String? area;
  String? image;
  String? latitude;
  String? longitude;
  String? sampleFee;
  String? fees;
  String? status;

  LabModel(
      {this.id,
      this.labName,
      this.drugLicenseNo,
      this.ownerName,
      this.contactNo,
      this.address,
      this.area,
      this.image,
      this.latitude,
      this.longitude,
      this.fees,
      this.status,
      this.sampleFee});

  LabModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    labName = json['lab_name'];
    drugLicenseNo = json['drug_license_no'];
    ownerName = json['owner_name'];
    contactNo = json['contact_no'];
    address = json['address'];
    area = json['area'];
    image = json['image'].toString() == 'null' ? '' : json['image'].toString();
    latitude = json['latitude'];
    longitude = json['longitude'];
    sampleFee = json['sample_fee'].toString();
    fees = json['fees'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lab_name'] = labName;
    data['drug_license_no'] = drugLicenseNo;
    data['owner_name'] = ownerName;
    data['contact_no'] = contactNo;
    data['address'] = address;
    data['area'] = area;
    data['image'] = image;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['sample_fee'] = sampleFee;
    data['fees'] = fees;
    data['status'] = status;
    return data;
  }
}
