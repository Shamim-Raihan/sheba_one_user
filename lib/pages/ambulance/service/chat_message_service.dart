import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shebaone/pages/ambulance/model/chat_message_model.dart';
import 'package:shebaone/pages/ambulance/model/store_message_model.dart';

class ChatMessageService extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Messages> messages = <Messages>[].obs;

  Future<void> fetchMessages() async {
    GetStorage.init();
    try {
      isLoading.value = true;
      print('orderccchhhhaaattttttt${GetStorage().read('Order_Id')}');
      final response = await http.get(
        Uri.parse(
            'https://www.shebaone.com/api/patient-user/chat/${GetStorage().read('Order_Id')}'),
        headers: {
          'Accept': 'application/json', // Set the content type
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('rrrrrrrrdddd===>${response.body}');
        final List<dynamic> messagesData = responseData['data']['messages'];
        messages.assignAll(
          messagesData
              .map<Messages>((message) => Messages.fromJson(message))
              .toList(),
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  //------------------sending message to rider---------------

  Future<void> sendMessage(String message) async {
    try {
      GetStorage.init();
      isLoading(true);

      final response = await http.post(
        Uri.parse(
            'https://www.shebaone.com/api/patient-user/chat/${GetStorage().read('Order_Id')}'),
        headers: {
          'Accept': 'application/json', // Set the content type
        }, // Replace with your actual API endpoint
        body: {'message': message},
      );

      if (response.statusCode == 200) {
        print('jjjjjjjjjjjjjjjjjjjjjjj');
        print(response.statusCode);
        final Map<String, dynamic> data = json.decode(response.body);
        final messageData = SendMessageModel.fromJson(data['data']);
        print('ppppkkkkkk====>$messageData');
        // You can use the messageData here or perform any other actions
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } finally {
      isLoading(false);
    }
  }
}
