import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gtech_app/Config.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:alice/alice.dart';

enum GTechAPI {
  getAppList,
  getAppDetail,
  getAppBuilds,
  getLocalDBAppList,
  getLocalDBAppDetailBuilds,
  getLocalDBAppBuildsList,
}

enum HTTPMethod { GET, POST }

// GTech API
// @author zhenteng.li@gtechdigi.com
// @time   2022/7/13
class API {
  final GTechAPI api;
  final HTTPMethod method;
  final Map<String, dynamic> parameters;

  API({required this.api, this.method = HTTPMethod.POST, this.parameters = const {}});

  static final Alice alice = Alice(
      showNotification: false,
      showInspectorOnShake: true,
      darkTheme: true);

  String get endpoint {
    switch (api) {
      case GTechAPI.getAppList:
        return '${Config.baseUrl}/app/listMy';
      case GTechAPI.getAppDetail:
        return '${Config.baseUrl}/app/view';
      case GTechAPI.getAppBuilds:
        return '${Config.baseUrl}/app/builds';
    }
    return "";
  }

  final String defaultErrorMessage =
      "There is something wrong with the internet connection";

  String queryStringFromMap(Map<String, dynamic> map) {
    List<String> params = [];

    map.forEach((key, value) {
      params.add("$key=$value");
    });
    return params.join("&");
  }

  Future<dynamic> request(
      {BuildContext? context}) async {
    http.Response response;
    var ioClient = IOClient(HttpClient());

    parameters["_api_key"] = Config.pgyerApiKey;

    switch (method) {
      case HTTPMethod.GET:
        response = await ioClient
            .get(Uri.parse("$endpoint?${queryStringFromMap(parameters)}"))
            .catchError((e) {
        });
        break;
      case HTTPMethod.POST:
        response = await ioClient
            .post(Uri.parse(endpoint), body: parameters)
            .catchError((e) {
        });
        break;
    }

    alice.onHttpResponse(response);

    var bodyString = utf8.decode(response.bodyBytes);
    log("param $parameters\n\n");
    log("\n\napi = $endpoint, code = ${response.statusCode}, response api $bodyString\n\n");

    final result = json.decode(bodyString);

    if (result == null) {
      return AssertionError("JSON parsing error");
    }

    if (result['code'] != 0) {
      return AssertionError(result['message']);
    }

    return result['data'];
  }
}