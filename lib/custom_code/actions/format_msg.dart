// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

Future<String> formatMsg(String request, dynamic payload) async {
  if (payload is List<String?>) {
    payload = payload.join('|');
  }
  int len = payload.length;
  String strLen = len.toString();
  while (strLen.length < 6) {
    strLen = "0" + strLen;
  }
  String format = strLen + "|" + payload;
  print(format);

  final message = {'type': request, 'payload': format};

  // Convert the map to a JSON string
  String jsonString = jsonEncode(message);

  return jsonString;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
