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
  String? newName;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
