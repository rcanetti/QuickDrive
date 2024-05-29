// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';

Future<String> logIn(
  String? username,
  String? password,
) async {
  List<String> data = [username as String, password as String];
  String strData = await formatMsg("login", data);
  Socket tempSocket = await Socket.connect("10.0.0.237", 8800);
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
