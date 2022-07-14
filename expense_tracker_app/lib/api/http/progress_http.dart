import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../res/progress_res.dart';
import '../urls.dart';

class ProgressHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<ProgressData> getUserProgress() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + ProgressUrls.getUserProgress),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      final resData = jsonDecode(response.body);

      return ProgressData.fromJson(resData);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<TopProgress> topUsersProgress() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + ProgressUrls.topUsersProgress),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      final resData = jsonDecode(response.body);

      return TopProgress.fromJson(resData);
    } catch (error) {
      return Future.error(error);
    }
  }
}
