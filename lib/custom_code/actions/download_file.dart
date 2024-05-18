// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future downloadFile(dynamic response, String fileName) async {
  // Add your function code here!
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
}
