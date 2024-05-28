import 'package:shebaone/models/healthcare_category_model.dart';
import 'package:shebaone/models/healthcare_product_model.dart';

class HealthCareCartModel {
  String? id;
  String? parentId;
  String? categoryId;
  String? name;
  String? purchasePrice;
  String? mrp;
  String? offerPercentage;
  String? offerPrice;
  String? quantity;
  String? userQuantity;
  String? warranty;
  List<Images>? images;
  HealthCareCategoryModel? category;

  HealthCareCartModel(
      {this.id,
      this.parentId,
      this.categoryId,
      this.name,
      this.purchasePrice,
      this.mrp,
      this.offerPercentage,
      this.offerPrice,
      this.quantity,
      this.userQuantity,
      this.warranty,
      this.images,
      this.category});

  HealthCareCartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    parentId = json['parent_id'].toString();
    categoryId = json['category_id'].toString();
    name = json['name'].toString();
    purchasePrice = json['purchase_price'].toString() == 'null'
        ? '0'
        : json['purchase_price'].toString();
    mrp = json['mrp'].toString() == 'null' ? '0' : json['mrp'].toString();
    warranty = json['warranty'].toString();
    offerPercentage = json['offer_percentage'].toString() == 'null'
        ? '0'
        : json['offer_percentage'].toString();
    offerPrice = json['offer_price'].toString() == 'null'
        ? '0'
        : json['offer_price'].toString();
    quantity = json['quantity'].toString() == 'null'
        ? '0'
        : json['quantity'].toString();
    userQuantity = json['user_quantity'].toString();
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    category = json['category'] != null
        ? HealthCareCategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['category_id'] = categoryId;
    data['name'] = name;
    data['purchase_price'] = purchasePrice;
    data['mrp'] = mrp;
    data['offer_percentage'] = offerPercentage;
    data['offer_price'] = offerPrice;
    data['quantity'] = quantity;
    data['user_quantity'] = userQuantity;
    data['warranty'] = warranty;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

// class Images {
//   String? id;
//   String? healthCareId;
//   String? image;
//   String? imagePath;
//
//   Images({this.id, this.healthCareId, this.image, this.imagePath});
//
//   Images.fromJson(Map<String, dynamic> json) {
//     id = json['id'].toString();
//     healthCareId = json['health_care_id'].toString();
//     image = json['image'].toString();
//     imagePath = json['image_path'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['health_care_id'] = healthCareId;
//     data['image'] = image;
//     data['image_path'] = imagePath;
//     return data;
//   }
// }
