class LabCartModel {
  String? id;
  String? testCategory;
  String? testName;
  String? testPrice;
  String? offerPrice;
  String? discountPercentage;
  String? about;
  String? preparation;
  String? result;
  String? labPrice;
  String? labId;
  String? labName;

  LabCartModel(
      {this.id,
      this.testCategory,
      this.testName,
      this.testPrice,
      this.offerPrice,
      this.discountPercentage,
      this.about,
      this.preparation,
      this.result,
      this.labPrice,
      this.labName,
      this.labId});

  LabCartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    testCategory = json['test_category'].toString();
    testName = json['test_name'];
    testPrice = json['test_price'].toString();
    offerPrice = json['offer_price'].toString();
    discountPercentage = json['discount_percentage'].toString();
    about = json['about'];
    preparation = json['preparation'];
    result = json['result'];
    labPrice = json['lab_price'].toString();
    labName = json['lab_name'].toString();
    labId = json['lab_id'].toString();
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
    data['lab_price'] = labPrice;
    data['lab_name'] = labName;
    data['lab_id'] = labId;
    return data;
  }
}
