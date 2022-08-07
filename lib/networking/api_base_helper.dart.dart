// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'api_exceptions.dart';

class ApiBaseHelper {
  final Dio dio = Dio(BaseOptions(connectTimeout: 10000));
  final String _baseUrl = "http://laravel.tifos.net/";

  static const String Suggest = "room/suggest/";

  Future<String> post(String url) async {
    print('🟢 Api Post, url $url');
    String responseJson;
    try {
      responseJson = _returnResponse(
        await dio.get(
          _baseUrl + url,
        ),
      );
    } on SocketException {
      print('🔴 No Internet connection');
      throw FetchDataException('No Internet connection');
    }
    print('🟢 api Post recieved!');
    return responseJson;
  }

  String _returnResponse(Response<String> response) {
    print("🟢statusCode  ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        var responseJson = response.data.toString();
        // print("🟢 200 $responseJson");
        return responseJson;
      case 400:
        print("🔴 400 ${response.data.toString()}");
        throw BadRequestException(response.data.toString());
      case 403:
        print("🔴 403 ${response.data.toString()}");
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
        print("🔴 500 ${response.data.toString()}");
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
