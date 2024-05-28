import 'package:flutter/material.dart';

Container customButton(String btnName) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      color: Color(0xFF0D6526),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Text(
          btnName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
