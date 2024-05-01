import 'package:flutter/material.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<String> _fileNames = ['pentagon file'];
  List<String> get fileNames => _fileNames;
  set fileNames(List<String> value) {
    _fileNames = value;
  }

  void addToFileNames(String value) {
    _fileNames.add(value);
  }

  void removeFromFileNames(String value) {
    _fileNames.remove(value);
  }

  void removeAtIndexFromFileNames(int index) {
    _fileNames.removeAt(index);
  }

  void updateFileNamesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    _fileNames[index] = updateFn(_fileNames[index]);
  }

  void insertAtIndexInFileNames(int index, String value) {
    _fileNames.insert(index, value);
  }

  String _ServerIP = '10.0.0.237';
  String get ServerIP => _ServerIP;
  set ServerIP(String value) {
    _ServerIP = value;
  }

  String _username = '';
  String get username => _username;
  set username(String value) {
    _username = value;
  }

  String _key = '';
  String get key => _key;
  set key(String value) {
    _key = value;
  }
}
