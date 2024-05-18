// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future downloadFile(dynamic response, String fileName) async {
  // Add your function code here!
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  File file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);

  // Open the file using the open_file package
  await OpenFile.open(filePath);
}
