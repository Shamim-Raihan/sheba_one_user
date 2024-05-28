import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/pages/ambulance/controller/chat_message_controller.dart';
import 'package:shebaone/pages/ambulance/view/payment_method.dart';

class ChatBotPage extends StatelessWidget {
  ChatBotPage({super.key});

  final ChatMessageController messageController =
      Get.put(ChatMessageController());

  TextEditingController _messageController = TextEditingController();

  // Scroll controller to control the scrolling of the ListView
  ScrollController _scrollController = ScrollController();



  // @override
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
     messageController.fetchMessages();


    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Color(0xFF0D6526),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() {
                if (messageController.messageService.messages.isNotEmpty) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 50),
                      curve: Curves.easeInOut,
                    );
                  });
                }
                return Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        messageController.messageService.messages.length,
                    itemBuilder: (context, index) {
                      var message =
                          messageController.messageService.messages[index];

                      // Check the sender value and determine the alignment
                      var isUser = message.sender == 'user';
                      var alignment = isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start;
                      return Row(
                        mainAxisAlignment: alignment,
                        children: [
                          if (!isUser)
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child:
                                  Image.asset("assets/images/Ellipse 42.png"),
                            ),
                          Flexible(
                            child: Padding(
                              padding: isUser ? EdgeInsets.only(bottom: 4.0,left: 40):EdgeInsets.only(bottom: 4.0,right: 40),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF0D6526),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(16.0),
                                    topLeft: Radius.circular(16.0),
                                    //bottomLeft: Radius.circular(16.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    message.message ?? '',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
               //Spacer(),
              SizedBox(height: 10,),
              TextField(
                minLines: 1,
                controller: _messageController,
                cursorColor: Color(0xFF0D6526),
                maxLines: null,
                // expands: true,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.justify,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0D6526),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0D6526),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Type your message',

                    suffixIcon: InkWell(
                      onTap: () {
                        messageController.messageService
                            .sendMessage(_messageController.text);
                        _messageController.clear();
                      },
                      child: Icon(
                        Icons.send,
                        color: Color(0xFF0D6526),
                      ),

                    )),
                textInputAction: TextInputAction.newline,
                onEditingComplete: (){
                  messageController.messageService.sendMessage(_messageController.text);
                  _messageController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
