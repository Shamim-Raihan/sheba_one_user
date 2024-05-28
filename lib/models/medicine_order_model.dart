class MedicineOrderModel {
  String? id;
  String? orderId;
  String? userId;
  String? pharmacyId;
  String? userName;
  String? userPhone;
  String? orderType;
  String? orderAmount;
  String? deliveryAddress;
  String? prescription;
  String? orderStatus;
  String? paymentStatus;
  String? paymentMethod;
  String? paymentTransactionId;
  String? bankTransactionId;
  String? orderFor;
  String? deliverymanId;
  String? createdAt;
  String? updatedAt;
  Pharmacy? pharmacy;

  MedicineOrderModel(
      {this.id,
      this.orderId,
      this.userId,
      this.pharmacyId,
      this.userName,
      this.userPhone,
      this.orderType,
      this.orderAmount,
      this.deliveryAddress,
      this.prescription,
      this.orderStatus,
      this.paymentStatus,
      this.paymentMethod,
      this.paymentTransactionId,
      this.bankTransactionId,
      this.orderFor,
      this.deliverymanId,
      this.createdAt,
      this.updatedAt,
      this.pharmacy});

  MedicineOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    orderId = json['order_id'].toString();
    userId = json['user_id'].toString();
    pharmacyId = json['pharmacy_id'].toString();
    userName = json['user_name'].toString();
    userPhone = json['user_phone'].toString();
    orderType = json['order_type'].toString();
    orderAmount = json['order_amount'].toString();
    deliveryAddress = json['delivery_address'].toString();
    prescription = json['prescription'].toString() == 'null'
        ? ''
        : json['prescription'].toString();
    orderStatus = json['order_status'].toString();
    paymentStatus = json['payment_status'].toString();
    paymentMethod = json['payment_method'].toString();
    paymentTransactionId = json['payment_transaction_id'].toString();
    bankTransactionId = json['bank_transaction_id'].toString() == 'null'
        ? ''
        : json['bank_transaction_id'].toString();
    orderFor = json['order_for'].toString();
    deliverymanId = json['deliveryman_id'].toString() == 'null'
        ? ''
        : json['deliveryman_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();

    pharmacy =
    json['pharmacy'] != null ? Pharmacy.fromJson(json['pharmacy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['pharmacy_id'] = pharmacyId;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['order_type'] = orderType;
    data['order_amount'] = orderAmount;
    data['delivery_address'] = deliveryAddress;
    data['prescription'] = prescription;
    data['order_status'] = orderStatus;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['payment_transaction_id'] = paymentTransactionId;
    data['bank_transaction_id'] = bankTransactionId;
    data['order_for'] = orderFor;
    data['deliveryman_id'] = deliverymanId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pharmacy != null) {
      data['pharmacy'] = pharmacy!.toJson();
    }
    return data;
  }
}

class MedicineSingleOrderItemModel {
  String? id;
  String? pharmacyOrderId;
  String? pharmacyId;
  String? medicineId;
  String? availability;
  String? medicineName;
  String? medicinePrice;
  String? qty;
  String? createdAt;
  String? updatedAt;
  Pharmacy? pharmacy;
  Medicine? medicine;

  MedicineSingleOrderItemModel(
      {this.id,
      this.pharmacyOrderId,
      this.pharmacyId,
      this.medicineId,
      this.availability,
      this.medicineName,
      this.medicinePrice,
      this.qty,
      this.createdAt,
      this.updatedAt,
      this.pharmacy,
      this.medicine});

  MedicineSingleOrderItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    pharmacyOrderId = json['pharmacy_order_id'].toString();
    pharmacyId = json['pharmacy_id'].toString();
    medicineId = json['medicine_id'].toString();
    availability = json['availability'].toString();
    medicineName = json['medicine_name'].toString();
    medicinePrice = json['medicine_price'].toString();
    qty = json['qty'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    pharmacy =
        json['pharmacy'] != null ? Pharmacy.fromJson(json['pharmacy']) : null;
    medicine =
        json['medicine'] != null ? Medicine.fromJson(json['medicine']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pharmacy_order_id'] = pharmacyOrderId;
    data['pharmacy_id'] = pharmacyId;
    data['medicine_id'] = medicineId;
    data['availability'] = availability;
    data['medicine_name'] = medicineName;
    data['medicine_price'] = medicinePrice;
    data['qty'] = qty;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pharmacy != null) {
      data['pharmacy'] = pharmacy!.toJson();
    }
    if (medicine != null) {
      data['medicine'] = medicine!.toJson();
    }
    return data;
  }
}

class Pharmacy {
  String? id;
  String? pharmacyName;
  String? drugLicenseNo;
  String? ownerName;
  String? contactNo;
  String? address;
  String? area;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  Pharmacy(
      {this.id,
      this.pharmacyName,
      this.drugLicenseNo,
      this.ownerName,
      this.contactNo,
      this.address,
      this.area,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt});

  Pharmacy.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    pharmacyName = json['pharmacy_name'].toString();
    drugLicenseNo = json['drug_license_no'].toString();
    ownerName = json['owner_name'].toString();
    contactNo = json['contact_no'].toString();
    address = json['address'].toString();
    area = json['area'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pharmacy_name'] = pharmacyName;
    data['drug_license_no'] = drugLicenseNo;
    data['owner_name'] = ownerName;
    data['contact_no'] = contactNo;
    data['address'] = address;
    data['area'] = area;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Medicine {
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
  String? slug;
  String? createdAt;
  String? updatedAt;

  Medicine(
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
      this.slug,
      this.createdAt,
      this.updatedAt});

  Medicine.fromJson(Map<String, dynamic> json) {
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
    slug = json['slug'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
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
    data['slug'] = slug;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
