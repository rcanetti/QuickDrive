import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetDownloadCall {
  static Future<ApiCallResponse> call({
    String? serverIP = '',
    String? username = '',
    String? key = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getDownload',
      apiUrl: 'http://$serverIP:8900/getDownload/$username',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {
        'key': key,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFilesCall {
  static Future<ApiCallResponse> call({
    String? serverIP = '',
    String? username = '',
    String? key = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getFiles',
      apiUrl: 'http://$serverIP:8900/getFiles/$username',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {
        'key': key,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class UploadCall {
  static Future<ApiCallResponse> call({
    String? serverIP = '',
    String? body = '',
    String? username = '',
    String? key = '',
  }) async {
    final ffApiRequestBody = '''
{"data": "$body", "key": "$key"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Upload',
      apiUrl: 'http://$serverIP:8900/Upload/$username',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class RemoveCall {
  static Future<ApiCallResponse> call({
    String? serverIP = '',
    String? body = '',
    String? username = '',
    String? key = '',
    String? len = '',
  }) async {
    final ffApiRequestBody = '''
{
  "data": "$body",
  "len": "$len",
  "key": "$key"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Remove',
      apiUrl: 'http://$serverIP:8900/Remove/$username',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class DownloadCall {
  static Future<ApiCallResponse> call({
    String? serverIP = '',
    String? body = '',
    String? username = '',
    String? key = '',
  }) async {
    final ffApiRequestBody = '''
{"data": "$body", "key":"$key" }''';
    return ApiManager.instance.makeApiCall(
      callName: 'Download',
      apiUrl: 'http://$serverIP:8900/Download/$username',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class RenameCall {
  static Future<ApiCallResponse> call({
    String? serverIP = '',
    String? body = '',
    String? username = '',
    String? key = '',
  }) async {
    final ffApiRequestBody = '''
{
  "data": "$body",
  "key": "$key"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Rename',
      apiUrl: 'http://$serverIP:8900/Rename/$username',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
