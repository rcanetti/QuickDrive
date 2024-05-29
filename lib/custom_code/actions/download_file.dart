// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

Future<void> downloadFile(
  String fileName,
  String serverIP,
  String username,
  String key,
) async {
  // Request storage permission
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    print('Storage permission not granted');
    return;
  }

  // Construct the URL to download the file with query parameters
  Uri url = Uri.parse('http://$serverIP:8900/getDownload/$username');
  Map<String, String> queryParams = {
    'key': key,
    'data': fileName,
  };
  url = url.replace(queryParameters: queryParams);

  // Create an instance of Dio
  var dio = Dio();

  // Get the directory to save the file
  Directory? directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/$fileName';

  try {
    // Download the file
    await dio.download(url.toString(), filePath);
    print('File saved to: $filePath');

    // Open the file
    OpenFile.open(filePath);
  } catch (e) {
    print('Error downloading file: $e');
  }
}
