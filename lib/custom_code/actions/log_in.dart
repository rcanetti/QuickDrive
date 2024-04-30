// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:quick_drive/custom_code/actions/formatMsg.dart';
import 'dart:convert';
import 'dart:io';

Future<String> logIn(
  String? username,
  String? password,
) async {
  List<String> data = [username as String, password as String];
  String strData = await formatMsg("login", data);
  Socket tempSocket = await Socket.connect("192.168.1.226", 8900);
  print("connected to regular socket");
  tempSocket.write(strData);
  List<int> serverData = await tempSocket.first;

  String message = utf8.decode(serverData);
  tempSocket.close();
  print('Received data from server: $message');

  // channel.sink.add(await formatMsg("register", username));
  return message;

  // if (message == 'true') {
  //   return true;
  // } else {
  //   return false;
  // }
}
