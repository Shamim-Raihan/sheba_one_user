import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shebaone/pages/ambulance/model/chat_message_model.dart';
import 'package:shebaone/pages/ambulance/service/chat_message_service.dart';
import 'package:http/http.dart' as http;

class ChatMessageController extends GetxController {
  final ChatMessageService messageService = ChatMessageService();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchMessages();
  }

  void fetchMessages() {
    print('iiiiiiiddd-->${GetStorage().read('Order_Id')}');
    messageService.fetchMessages();
    //  messageService.fetchMessages(int.parse('${GetStorage().read('userId')}'));
  }
}
