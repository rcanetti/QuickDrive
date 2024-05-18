// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

Future downloadFile(
  String fileName,
  String serverIP,
  String username,
  String key,
) async {
  // Add your function code here!
  // Construct the URL to download the file with query parameters
  Uri url = Uri.parse('http://$serverIP:8900/getDownload/$username');
  Map<String, String> queryParams = {
    'key': key,
    'data': fileName,
  };
  url = url.replace(queryParameters: queryParams);

  // Make an HTTP GET request to download the file
  var response = await http.get(url);

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Get the bytes of the file content
    List<int> fileBytes = response.bodyBytes;

    // Get the directory to save the file
    String downloadsDirectory = (await getDownloadsDirectory())!.path;

    // Construct the file path
    String filePath = '$downloadsDirectory/$fileName';

    // Save the file to the device
    File file = File(filePath);
    await file.writeAsBytes(fileBytes);
    await dio.download(downloadsDirectory, fileName);

    OpenFile.open(filePath);

    print('File saved to: $filePath');
  } else {
    print('Failed to download file: ${response.statusCode}');
  }
}
