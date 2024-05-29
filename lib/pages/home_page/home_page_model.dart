import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - uploadFile] action in FloatingActionButton widget.
  List<String>? uploadData;
  // Stores action output result for [Backend Call - API (getFiles)] action in FloatingActionButton widget.
  ApiCallResponse? newUploadJSON;
  // Stores action output result for [Custom Action - getFiles] action in FloatingActionButton widget.
  List<String>? newUploadedFiles;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
