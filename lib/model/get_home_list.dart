import 'dart:convert';

import 'package:flutter/services.dart';

String _data = "Load JSON Data";
List res = [];
Future<List> loadJsonAsset() async {
  _data = "";
  String loadData = await rootBundle.loadString('json/listData.json');
  final jsonResponse = json.decode(loadData);

  for (var i = 0; i < jsonResponse.length; i++) {
    res.add(jsonResponse[i]);
  }
  return res;
}
