// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> getFiles(dynamic response) async {
  // Add your function code here!
  print(response);
  Map<String, dynamic> data = jsonDecode(response);
  Map<String, dynamic> jsonMap = data['data'];
  String type = jsonMap['type'];
  String payload = jsonMap['payload'];
  List<String> files = [];

  try {
    files = payload.split("|");
    // files = files.sublist(1, files.length - 1);
  } catch (e) {
    files = [payload];
  }

  return files;
}
