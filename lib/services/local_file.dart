import 'dart:convert';

import 'package:flutter/services.dart';

class LocalFileDatabase {
  Future<dynamic> loadData(String cat, {String? city}) async {
    var data = await rootBundle.loadString("assets/files/$cat.json");
    final res = json.decode(data);
    if (res['status'] == 200) {
      if (cat == 'districts') {
        return res['places'];
      } else {
        dynamic area = [];
        res['places'].forEach((place) {
          if (place['name'].toString().toLowerCase() == city!.toLowerCase()) {
            area = place['areas'];
          }
        });
        return area;
        // return res['places'];
      }
    }
    return 'lol';
  }
}
