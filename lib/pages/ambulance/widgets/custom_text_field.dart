import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.htext,
    required this.ctrl,
    required this.ico
  });
  final String htext;
  final TextEditingController ctrl;
  final IconData ico;
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54), borderRadius: BorderRadius.circular(8),),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(8),),
        hintText: htext,
       prefixIcon: Icon(Icons.my_location,color: Colors.black,)
      ),
    );
  }
}