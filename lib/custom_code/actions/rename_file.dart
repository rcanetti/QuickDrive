// Automatic FlutterFlow imports
import '/actions/actions.dart' as action_blocks;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<String>> renameFile(
  String? oldFileName,
  String? newFileName,
) async {
  // Add your function code here!
  String joinedString = oldFileName! + "|" + newFileName!;

  int len = joinedString.length;
  String strLen = len.toString();
  while (strLen.length < 6) {
    strLen = "0" + strLen;
  }
  return [strLen, joinedString];
}
