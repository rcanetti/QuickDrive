// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

Future<String> detectFileType(File file) async {
  try {
    // Open the file in read mode
    RandomAccessFile raf = await file.open();

    // Read the first few bytes
    List<int> bytes = await raf.read(10);
    await raf.close();

    // Determine the file type based on the first few bytes
    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'jpeg';
    } else if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    } else if (bytes.length >= 4 &&
        String.fromCharCodes(bytes.take(4)) == '%PDF') {
      return 'pdf';
    } else if (bytes.length >= 8 &&
        String.fromCharCodes(bytes.take(8)) == 'PK\x03\x04\x14\x00\x06\x00') {
      return 'zip';
    } else if (bytes.length >= 4 &&
        String.fromCharCodes(bytes.take(4)) == 'Rar!') {
      return 'rar';
    } else if (bytes.length >= 4 &&
        String.fromCharCodes(bytes.take(4)) == 'fLaC') {
      return 'flac';
    } else if (bytes.length >= 3 &&
        String.fromCharCodes(bytes.take(3)) == 'ID3') {
      return 'mp3';
    } else if (bytes.length >= 8 &&
        String.fromCharCodes(bytes.take(8)) == '\x00\x00\x00\x18ftypisom') {
      return 'mp4';
    } else if (bytes.length >= 4 &&
        String.fromCharCodes(bytes.take(4)) == 'GIF8') {
      return 'gif';
    } else if (bytes.length >= 3 &&
        String.fromCharCodes(bytes.take(3)) == 'BM') {
      return 'bmp';
    } else if (bytes.length >= 4 &&
        String.fromCharCodes(bytes.take(4)) == 'II*\x00') {
      return 'tiff';
    } else if (bytes.length >= 4 &&
        String.fromCharCodes(bytes.take(4)) == 'MM\x00*') {
      return 'tiff';
    } else {
      return 'Unknown';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

Future<String> formatMsg(String request, dynamic payload) async {
  if (request == 'upload') {
    int len = payload.readAsBytesSync().length;
    String strLen = len.toString();
    String fileType = await detectFileType(payload);
    List<int> bytes = await payload.readAsBytes();
    while (strLen.length < 6) {
      strLen = "0" + strLen;
    }
    String format = "|" + strLen + "|" + fileType + "|" + bytes.toString();
    final message = {'type': request, 'payload': format};

    // Convert the map to a JSON string
    final jsonString = jsonEncode(message);

    return jsonString;
  }

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
  final jsonString = jsonEncode(message);

  return jsonString;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
