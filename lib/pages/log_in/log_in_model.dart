import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'log_in_widget.dart' show LogInWidget;
import 'package:flutter/material.dart';

class LogInModel extends FlutterFlowModel<LogInWidget> {
  ///  Local state fields for this page.

  String? username;

  String? password;

  String? confirmPassword;

  String? email;

  String? phoneNumber;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Stores action output result for [Custom Action - logIn] action in LogIn widget.
  String? key;
  // Stores action output result for [Backend Call - API (getFiles)] action in LogIn widget.
  ApiCallResponse? fileNames;
  // Stores action output result for [Custom Action - getFiles] action in LogIn widget.
  List<String>? newFiles;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // State field(s) for usernameAddress_Create widget.
  FocusNode? usernameAddressCreateFocusNode;
  TextEditingController? usernameAddressCreateTextController;
  String? Function(BuildContext, String?)?
      usernameAddressCreateTextControllerValidator;
  // State field(s) for emailAddress_Create widget.
  FocusNode? emailAddressCreateFocusNode;
  TextEditingController? emailAddressCreateTextController;
  String? Function(BuildContext, String?)?
      emailAddressCreateTextControllerValidator;
  // State field(s) for phoneNumberAddress_Create widget.
  FocusNode? phoneNumberAddressCreateFocusNode;
  TextEditingController? phoneNumberAddressCreateTextController;
  String? Function(BuildContext, String?)?
      phoneNumberAddressCreateTextControllerValidator;
  // State field(s) for password_Create widget.
  FocusNode? passwordCreateFocusNode1;
  TextEditingController? passwordCreateTextController1;
  late bool passwordCreateVisibility1;
  String? Function(BuildContext, String?)?
      passwordCreateTextController1Validator;
  // State field(s) for password_Create widget.
  FocusNode? passwordCreateFocusNode2;
  TextEditingController? passwordCreateTextController2;
  late bool passwordCreateVisibility2;
  String? Function(BuildContext, String?)?
      passwordCreateTextController2Validator;
  // Stores action output result for [Custom Action - signUp] action in Button widget.
  String? canLog;
  // Stores action output result for [Backend Call - API (getFiles)] action in Button widget.
  ApiCallResponse? fileNamesSignUp;
  // Stores action output result for [Custom Action - getFiles] action in Button widget.
  List<String>? newFilesSignUp;
  // State field(s) for signCheckBox widget.
  bool? signCheckBoxValue;
  // State field(s) for usernameAddress widget.
  FocusNode? usernameAddressFocusNode;
  TextEditingController? usernameAddressTextController;
  String? Function(BuildContext, String?)?
      usernameAddressTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Custom Action - logIn] action in Button widget.
  String? canLog2;
  // Stores action output result for [Backend Call - API (getFiles)] action in Button widget.
  ApiCallResponse? fileNamesLogIn;
  // Stores action output result for [Custom Action - getFiles] action in Button widget.
  List<String>? newFilesLogIn;
  // State field(s) for logCheckBox widget.
  bool? logCheckBoxValue;

  @override
  void initState(BuildContext context) {
    passwordCreateVisibility1 = false;
    passwordCreateVisibility2 = false;
    passwordVisibility = false;
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    tabBarController?.dispose();
    usernameAddressCreateFocusNode?.dispose();
    usernameAddressCreateTextController?.dispose();

    emailAddressCreateFocusNode?.dispose();
    emailAddressCreateTextController?.dispose();

    phoneNumberAddressCreateFocusNode?.dispose();
    phoneNumberAddressCreateTextController?.dispose();

    passwordCreateFocusNode1?.dispose();
    passwordCreateTextController1?.dispose();

    passwordCreateFocusNode2?.dispose();
    passwordCreateTextController2?.dispose();

    usernameAddressFocusNode?.dispose();
    usernameAddressTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
