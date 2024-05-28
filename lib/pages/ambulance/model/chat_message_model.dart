class ChatMessageModel {
  bool? error;
  String? message;
  int? status;
  Data? data;

  ChatMessageModel({this.error, this.message, this.status, this.data});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? orderId;
  List<Messages>? messages;

  Data({this.orderId, this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  int? id;
  int? patientRideOrderId;
  int? patientRiderId;
  int? userId;
  String? message;
  String? sender;
  String? createdAt;
  String? updatedAt;

  Messages({
    this.id,
    this.patientRideOrderId,
    this.patientRiderId,
    this.userId,
    this.message,
    this.sender,
    this.createdAt,
    this.updatedAt,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientRideOrderId = json['patient_ride_order_id'];
    patientRiderId = json['patient_rider_id'];
    userId = json['user_id'];
    message = json['message'];
    sender = json['sender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_ride_order_id'] = this.patientRideOrderId;
    data['patient_rider_id'] = this.patientRiderId;
    data['user_id'] = this.userId;
    data['message'] = this.message;
    data['sender'] = this.sender;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

