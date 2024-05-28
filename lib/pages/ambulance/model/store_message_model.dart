class SendMessageModel {
  final String message;

  SendMessageModel({required this.message});

  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(message: json['message']);
  }
}
