// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';
import 'package:file_picker/file_picker.dart';

Future<List<String>> uploadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path!);

    String filename = result.files.single.name;
    String filePath = result.files.single.path!;
    String fileType = 'application'; // Replace with actual file type if known
    String fileFormat = filePath
        .split('.')
        .last; // Extract the file format from the file extension

    return [filename, filePath, fileType, fileFormat];
  }
  return ['No file picked']; //no file picked
}
