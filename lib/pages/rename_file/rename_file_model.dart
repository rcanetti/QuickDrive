import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'rename_file_widget.dart' show RenameFileWidget;
import 'package:flutter/material.dart';

class RenameFileModel extends FlutterFlowModel<RenameFileWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - renameFile] action in Button widget.
  List<String>? renameMsg;
  // Stores action output result for [Backend Call - API (Rename)] action in Button widget.
  ApiCallResponse? renameResponse;
  // Stores action output result for [Backend Call - API (getFiles)] action in Button widget.
  ApiCallResponse? fileListMsg;
  // Stores action output result for [Custom Action - getFiles] action in Button widget.
  List<String>? fileList;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
