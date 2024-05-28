class MedicineModel {
  String? id;
  String? companyId;
  String? name;
  String? genericId;
  String? packsizeId;
  String? dosagesId;
  String? strengthId;
  String? mrp;
  String? purchasePrice;
  String? offerPercentage;
  String? offerPrice;
  String? quantity;
  String? unitCount;
  String? sideEffects;
  String? ingredients;
  String? contradictions;
  String? precautions;
  List<MedicineImage>? images;
  Company? company;
  Generic? generic;
  Generic? dosages;
  Generic? packsizes;
  Generic? strength;

  MedicineModel(
      {this.id,
      this.companyId,
      this.name,
      this.genericId,
      this.packsizeId,
      this.dosagesId,
      this.strengthId,
      this.mrp,
      this.purchasePrice,
      this.offerPercentage,
      this.offerPrice,
      this.quantity,
      this.unitCount,
      this.sideEffects,
      this.ingredients,
      this.contradictions,
      this.precautions,
      this.images,
      this.company,
      this.generic,
      this.dosages,
      this.packsizes,
      this.strength});

  MedicineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    companyId = json['company_id'].toString();
    name = json['name'].toString();
    genericId = json['generic_id'].toString();
    packsizeId = json['packsize_id'].toString();
    dosagesId = json['dosages_id'].toString();
    strengthId = json['strength_id'].toString();
    mrp = json['mrp'].toString();
    purchasePrice = json['purchase_price'].toString();
    offerPercentage = json['offer_percentage'].toString();
    offerPrice = json['offer_price'].toString();
    quantity = json['quantity'].toString();
    unitCount = json['unit_count'].toString() == 'null'
        ? ''
        : json['unit_count'].toString();
    sideEffects = json['side_effects'].toString() == 'null'
        ? ''
        : json['side_effects'].toString();
    ingredients = json['ingredients'].toString() == 'null'
        ? ''
        : json['ingredients'].toString();
    contradictions = json['contradictions'].toString() == 'null'
        ? ''
        : json['contradictions'].toString();
    precautions = json['precautions'].toString() == 'null'
        ? ''
        : json['precautions'].toString();
    if (json['images'] != null) {
      images = <MedicineImage>[];
      json['images'].forEach((v) {
        images!.add(MedicineImage.fromJson(v));
      });
    } else {
      images = <MedicineImage>[];
    }
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    generic =
        json['generic'] != null ? Generic.fromJson(json['generic']) : null;
    dosages =
        json['dosages'] != null ? Generic.fromJson(json['dosages']) : null;
    packsizes =
        json['packsizes'] != null ? Generic.fromJson(json['packsizes']) : null;
    strength =
        json['strength'] != null ? Generic.fromJson(json['strength']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['name'] = name;
    data['generic_id'] = genericId;
    data['packsize_id'] = packsizeId;
    data['dosages_id'] = dosagesId;
    data['strength_id'] = strengthId;
    data['mrp'] = mrp;
    data['purchase_price'] = purchasePrice;
    data['offer_percentage'] = offerPercentage;
    data['offer_price'] = offerPrice;
    data['quantity'] = quantity;
    data['unit_count'] = unitCount;
    data['side_effects'] = sideEffects;
    data['ingredients'] = ingredients;
    data['contradictions'] = contradictions;
    data['precautions'] = precautions;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (generic != null) {
      data['generic'] = generic!.toJson();
    }
    if (dosages != null) {
      data['dosages'] = dosages!.toJson();
    }
    if (packsizes != null) {
      data['packsizes'] = packsizes!.toJson();
    }
    if (strength != null) {
      data['strength'] = strength!.toJson();
    }
    return data;
  }
}

class Company {
  String? id;
  String? name;
  String? website;
  String? address;
  String? createdAt;
  String? updatedAt;

  Company(
      {this.id,
      this.name,
      this.website,
      this.address,
      this.createdAt,
      this.updatedAt});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    website = json['website'].toString();
    address =
        json['address'].toString() == 'null' ? '' : json['address'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['website'] = website;
    data['address'] = address;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Generic {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Generic({this.id, this.name, this.createdAt, this.updatedAt});

  Generic.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MedicineImage {
  String? id;
  String? image;
  String? medicineId;
  String? createdAt;
  String? updatedAt;
  String? imagePath;

  MedicineImage(
      {this.id,
      this.image,
      this.medicineId,
      this.createdAt,
      this.updatedAt,
      this.imagePath});

  MedicineImage.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    image = json['image'].toString();
    medicineId = json['medicine_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    imagePath = json['image_path'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['medicine_id'] = medicineId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_path'] = imagePath;
    return data;
  }
}
