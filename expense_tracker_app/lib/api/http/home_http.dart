import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/api/res/home_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class HomeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<HomeData> viewHome() async {
    // try {} on SocketException catch (_) {
    //   return HomeData();
    // }

    final response = await get(
      Uri.parse(routeUrl + "user/getHome"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return HomeData.fromJson(jsonDecode(response.body));
  }
}
