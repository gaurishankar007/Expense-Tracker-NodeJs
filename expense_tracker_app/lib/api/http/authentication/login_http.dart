// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart';

import '../../urls.dart';

class LoginHttp {
  final routeUrl = ApiUrls.routeUrl;

  Future<Map> login(String email, String password) async {
    try {
      Map<String, String> userData = {
        "email": email,
        "password": password,
      };

      final response =
          await post(Uri.parse(routeUrl + "user/login"), body: userData);

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body) as Map,
      };
    } catch (error) {
      return Future.error(error);
    }
  }
}
