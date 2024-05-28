class LabOrderModel {
  String? id;
  String? orderNo;
  String? userId;
  String? name;
  String? mobile;
  String? email;
  String? address;
  String? total;
  String? serviceCharge;
  String? grandTotal;
  String? paymentId;
  String? bankTransactionId;
  String? paymentMethod;
  String? totalItem;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  List<OrderDetail>? orderDetail;

  LabOrderModel(
      {this.id,
      this.orderNo,
      this.userId,
      this.name,
      this.mobile,
      this.email,
      this.address,
      this.total,
      this.serviceCharge,
      this.grandTotal,
      this.paymentId,
      this.bankTransactionId,
      this.paymentMethod,
      this.totalItem,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.orderDetail});

  LabOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    orderNo = json['order_no'].toString() == 'null' ? '' : json['order_no'].toString();
    userId = json['user_id'].toString() == 'null' ? '' : json['user_id'].toString();
    name = json['name'].toString() == 'null' ? '' : json['name'].toString();
    mobile = json['mobile'].toString() == 'null' ? '' : json['mobile'].toString();
    email = json['email'].toString() == 'null' ? '' : json['email'].toString();
    address = json['address'].toString() == 'null' ? '' : json['address'].toString();
    total = json['total'].toString() == 'null' ? '' : json['total'].toString();
    serviceCharge = json['service_charge'].toString() == 'null' ? '' : json['service_charge'].toString();
    grandTotal = json['grand_total'].toString() == 'null' ? '' : json['grand_total'].toString();
    paymentId = json['payment_id'].toString() == 'null' ? '' : json['payment_id'].toString();
    bankTransactionId = json['bank_transaction_id'].toString() == 'null' ? '' : json['bank_transaction_id'].toString();
    paymentMethod = json['payment_method'].toString() == 'null' ? '' : json['payment_method'].toString();
    totalItem = json['total_item'].toString() == 'null' ? '' : json['total_item'].toString();
    orderStatus = json['order_status'].toString() == 'null' ? '' : json['order_status'].toString();
    createdAt = json['created_at'].toString() == 'null' ? '' : json['created_at'].toString();
    updatedAt = json['updated_at'].toString() == 'null' ? '' : json['updated_at'].toString();
    if (json['order_details'] != null) {
      orderDetail = <OrderDetail>[];
      json['order_details'].forEach((v) {
        orderDetail!.add(OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_no'] = orderNo;
    data['user_id'] = userId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['address'] = address;
    data['total'] = total;
    data['service_charge'] = serviceCharge;
    data['grand_total'] = grandTotal;
    data['payment_id'] = paymentId;
    data['bank_transaction_id'] = bankTransactionId;
    data['payment_method'] = paymentMethod;
    data['total_item'] = totalItem;
    data['order_status'] = orderStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (orderDetail != null) {
      data['order_details'] = orderDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetail {
  String? id;
  String? testOrderId;
  String? orderNo;
  String? sampleId;
  String? labId;
  String? testId;
  String? labName;
  String? testName;
  String? testPrice;
  String? homeSample;
  String? createdAt;
  String? updatedAt;

  OrderDetail(
      {this.id,
      this.testOrderId,
      this.orderNo,
      this.sampleId,
      this.labId,
      this.testId,
      this.labName,
      this.testName,
      this.testPrice,
      this.homeSample,
      this.createdAt,
      this.updatedAt});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() == 'null' ? '' : json['id'].toString();
    testOrderId = json['test_order_id'].toString() == 'null' ? '' : json['test_order_id'].toString();
    orderNo = json['order_no'].toString() == 'null' ? '' : json['order_no'].toString();
    sampleId = json['sample_id'].toString() == 'null' ? '' : json['sample_id'].toString();
    labId = json['lab_id'].toString() == 'null' ? '' : json['lab_id'].toString();
    testId = json['test_id'].toString() == 'null' ? '' : json['test_id'].toString();
    labName = json['lab_name'].toString() == 'null' ? '' : json['lab_name'].toString();
    testName = json['test_name'].toString() == 'null' ? '' : json['test_name'].toString();
    testPrice = json['test_price'].toString() == 'null' ? '' : json['test_price'].toString();
    homeSample = json['home_sample'].toString() == 'null' ? '' : json['home_sample'].toString();
    createdAt = json['created_at'].toString() == 'null' ? '' : json['created_at'].toString();
    updatedAt = json['updated_at'].toString() == 'null' ? '' : json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['test_order_id'] = testOrderId;
    data['order_no'] = orderNo;
    data['sample_id'] = sampleId;
    data['lab_id'] = labId;
    data['test_id'] = testId;
    data['lab_name'] = labName;
    data['test_name'] = testName;
    data['test_price'] = testPrice;
    data['home_sample'] = homeSample;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
