// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';

Future<String> signUp(
  String? username,
  String? email,
  String? phone,
  String? password,
) async {
  List<String> data = [
    username as String,
    email as String,
    phone as String,
    password as String
  ];
  String strData = await formatMsg("signup", data);
  Socket tempSocket = await Socket.connect("10.0.0.237", 8800);
  tempSocket.write(strData);

  // Receive data from the server
  List<int> serverData = await tempSocket.first;

  String message = utf8.decode(serverData);
  tempSocket.close();
  print('Received data from server: $message');
  return message;
}
