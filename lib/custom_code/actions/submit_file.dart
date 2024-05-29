// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<void> submitFile(String filePath, String filename, String fileType,
    String fileFormat, String username, String key) async {
  ///MultiPart request

  // API endpoint URL
  Uri url = Uri.parse('http://10.0.0.237:8900/Upload/$username');

  // Set up the request
  var request = http.MultipartRequest('POST', url);

  // Add the ZIP file to the request
  var file = await http.MultipartFile.fromPath('file', filePath,
      contentType: MediaType(fileType, fileFormat));

  request.files.add(file);
  request.fields['key'] = key;

  // Send the request
  var res = await request.send();
  print("This is response:" + res.toString());
  // return res.statusCode;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
