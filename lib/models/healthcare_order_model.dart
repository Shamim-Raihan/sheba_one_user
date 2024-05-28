class HealthcareOrderModel {
  String? id;
  String? userId;
  String? orderId;
  String? userName;
  String? userMobile;
  String? userEmail;
  String? userAddress;
  String? district;
  String? area;
  String? lat;
  String? lon;
  String? deliveredDate;
  String? refferelCode;
  String? comments;
  String? totalItems;
  String? productsBuyPrice;
  String? productsOrgSellPrice;
  String? productsSellPrice;
  String? collectedAmount;
  String? discountAmount;
  String? couponAmount;
  String? shippingCharge;
  String? paymentId;
  String? paymentMethod;
  String? paymentStatus;
  String? paymentTransactionId;
  String? bankTransactionId;
  String? deliveryStatus;
  String? orderStatus;
  String? couponCode;
  String? deliverymanId;
  String? createdAt;
  String? updatedAt;

  HealthcareOrderModel(
      {this.id,
      this.userId,
      this.orderId,
      this.userName,
      this.userMobile,
      this.userEmail,
      this.userAddress,
      this.district,
      this.area,
      this.lat,
      this.lon,
      this.deliveredDate,
      this.refferelCode,
      this.comments,
      this.totalItems,
      this.productsBuyPrice,
      this.productsOrgSellPrice,
      this.productsSellPrice,
      this.collectedAmount,
      this.discountAmount,
      this.couponAmount,
      this.shippingCharge,
      this.paymentId,
      this.paymentMethod,
      this.paymentStatus,
      this.paymentTransactionId,
      this.bankTransactionId,
      this.deliveryStatus,
      this.orderStatus,
      this.couponCode,
      this.deliverymanId,
      this.createdAt,
      this.updatedAt});

  HealthcareOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    orderId = json['order_id'].toString();
    userName = json['user_name'].toString();
    userMobile = json['user_mobile'].toString();
    userEmail = json['user_email'].toString() == 'null' ? '' : json['user_email'].toString();
    userAddress = json['user_address'].toString();
    district = json['district'].toString();
    area = json['area'].toString();
    refferelCode = json['refferel_code'].toString() == 'null' ? '' : json['refferel_code'].toString();
    lat = json['lat'].toString() == 'null' ? '' : json['lat'].toString();
    lon = json['lon'].toString() == 'null' ? '' : json['lon'].toString();
    comments = json['comments'].toString() == 'null' ? '' : json['comments'].toString();
    deliveredDate = json['delivered_date'].toString() == 'null' ? '' : json['delivered_date'].toString();
    totalItems = json['total_items'].toString();
    productsBuyPrice = json['products_buy_price'].toString();
    productsOrgSellPrice = json['products_org_sell_price'].toString();
    productsSellPrice = json['products_sell_price'].toString();
    collectedAmount = json['collected_amount'].toString();
    discountAmount = json['discount_amount'].toString();
    couponAmount = json['coupon_amount'].toString();
    shippingCharge = json['shipping_charge'].toString();
    paymentId = json['payment_id'].toString();
    paymentMethod = json['payment_method'].toString();
    paymentStatus = json['payment_status'].toString();
    paymentTransactionId =
        json['payment_transaction_id'].toString() == 'null' ? '' : json['payment_transaction_id'].toString();
    bankTransactionId = json['bank_transaction_id'].toString() == 'null' ? '' : json['bank_transaction_id'].toString();
    deliveryStatus = json['delivery_status'].toString();
    orderStatus = json['order_status'].toString();
    couponCode = json['coupon_code'].toString() == 'null' ? '' : json['coupon_code'].toString();
    deliverymanId = json['deliveryman_id'].toString() == 'null' ? '' : json['deliveryman_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['user_name'] = userName;
    data['user_mobile'] = userMobile;
    data['user_email'] = userEmail;
    data['user_address'] = userAddress;
    data['district'] = district;
    data['area'] = area;
    data['lat'] = lat;
    data['lon'] = lon;
    data['delivered_date'] = deliveredDate;
    data['refferel_code'] = refferelCode;
    data['comments'] = comments;
    data['total_items'] = totalItems;
    data['products_buy_price'] = productsBuyPrice;
    data['products_org_sell_price'] = productsOrgSellPrice;
    data['products_sell_price'] = productsSellPrice;
    data['collected_amount'] = collectedAmount;
    data['discount_amount'] = discountAmount;
    data['coupon_amount'] = couponAmount;
    data['shipping_charge'] = shippingCharge;
    data['payment_id'] = paymentId;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['payment_transaction_id'] = paymentTransactionId;
    data['bank_transaction_id'] = bankTransactionId;
    data['delivery_status'] = deliveryStatus;
    data['order_status'] = orderStatus;
    data['coupon_code'] = couponCode;
    data['deliveryman_id'] = deliverymanId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class HealthcareSingleOrderModel {
  String? id;
  String? pharmacyOrderId;
  String? pharmacyId;
  String? productId;
  String? productName;
  String? productPrice;
  String? availability;
  String? qty;
  String? createdAt;
  String? updatedAt;

  HealthcareSingleOrderModel(
      {this.id,
        this.pharmacyOrderId,
        this.pharmacyId,
        this.productId,
        this.productName,
        this.productPrice,
        this.availability,
        this.qty,
        this.createdAt,
        this.updatedAt});

  HealthcareSingleOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null'? '':json['id'].toString()  ;
    pharmacyOrderId = json['pharmacy_order_id'].toString() == 'null'? '':json['pharmacy_order_id'].toString()  ;
    pharmacyId = json['pharmacy_id'].toString() == 'null'? '':json['pharmacy_id'].toString()  ;
    productId = json['product_id'].toString() == 'null'? '':json['product_id'].toString()  ;
    productName = json['product_name'].toString() == 'null'? '':json['product_name'].toString()  ;
    productPrice = json['product_price'].toString() == 'null'? '':json['product_price'].toString()  ;
    availability = json['availability'].toString() == 'null'? '':json['availability'].toString()  ;
    qty = json['qty'].toString() == 'null'? '':json['qty'].toString()  ;
    createdAt = json['created_at'].toString() == 'null'? '':json['created_at'].toString()  ;
    updatedAt = json['updated_at'].toString() == 'null'? '':json['updated_at'].toString()  ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pharmacy_order_id'] = this.pharmacyOrderId;
    data['pharmacy_id'] = this.pharmacyId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['availability'] = this.availability;
    data['qty'] = this.qty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
