import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class RecipeCall {
  static Future<ApiCallResponse> call({
    String? q,
  }) async {
    q ??= '';

    return ApiManager.instance.makeApiCall(
      callName: 'recipe',
      apiUrl: 'https://www.googleapis.com/customsearch/v1',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'key': "AIzaSyAnTYkDrVIhnq28xEilr9qtf-4_Xs04r-Q",
        'cx': "c2e6aaeeec3e34278",
        'q': q,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<String>? meals(dynamic response) => (getJsonField(
        response,
        r'''$.meals[:].strMeal''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? categories(dynamic response) => (getJsonField(
        response,
        r'''$.meals[:].strCategory''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? images(dynamic response) => (getJsonField(
        response,
        r'''$.meals[:].strMealThumb''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class TestCall {
  static Future<ApiCallResponse> call({
    String? url = '',
  }) async {
    final ffApiRequestBody = '''
{
  "url": "${escapeStringForJson(url)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'test',
      apiUrl: 'https://bite-scraper-api-1.onrender.com/api/parseRecipe',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  static String? notes(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.notes''',
      ));
  static List<String>? ingredients(dynamic response) => (getJsonField(
        response,
        r'''$.ingredients''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? instructions(dynamic response) => (getJsonField(
        response,
        r'''$.instructions''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static String? cookingtime(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.cooking_time''',
      ));
  static String? servings(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.servings''',
      ));
  static double? rating(dynamic response) => castToType<double>(getJsonField(
        response,
        r'''$.rating''',
      ));
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

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
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
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
