import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - uploadFile] action in FloatingActionButton widget.
  String? uploadData;
  // Stores action output result for [Backend Call - API (Upload)] action in FloatingActionButton widget.
  ApiCallResponse? uploadResponse;
  // Stores action output result for [Backend Call - API (getFiles)] action in FloatingActionButton widget.
  ApiCallResponse? newUploadJSON;
  // Stores action output result for [Custom Action - getFiles] action in FloatingActionButton widget.
  List<String>? newUploadedFiles;
  // Stores action output result for [Custom Action - deleteFile] action in Text widget.
  List<String>? newFileList;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
