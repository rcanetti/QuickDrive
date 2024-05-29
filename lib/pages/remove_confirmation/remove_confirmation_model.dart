import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'remove_confirmation_widget.dart' show RemoveConfirmationWidget;
import 'package:flutter/material.dart';

class RemoveConfirmationModel
    extends FlutterFlowModel<RemoveConfirmationWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - removeFile] action in Button widget.
  List<String>? removeMsg;
  // Stores action output result for [Backend Call - API (Remove)] action in Button widget.
  ApiCallResponse? removeResponse;
  // Stores action output result for [Backend Call - API (getFiles)] action in Button widget.
  ApiCallResponse? fileListMsg;
  // Stores action output result for [Custom Action - getFiles] action in Button widget.
  List<String>? fileList;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
