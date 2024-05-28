class HealthCareCategoryModel {
  String? id;
  String? name;
  String? slug;
  String? parentId;
  String? discount;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imagePath;

  HealthCareCategoryModel(
      {this.id,
      this.name,
      this.slug,
      this.parentId,
      this.discount,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.imagePath});

  HealthCareCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    slug = json['slug'].toString();
    parentId = json['parent_id'].toString();
    discount = json['discount'].toString();
    image = json['image'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    imagePath = json['image_path'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['parent_id'] = parentId;
    data['discount'] = discount;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_path'] = imagePath;
    return data;
  }
}
