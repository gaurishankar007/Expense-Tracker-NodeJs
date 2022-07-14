import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/api/res/progress_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../urls.dart';

class AchievementHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<List<Achievement>> getAllAchievements() async {
    try {
      final response = await get(
        Uri.parse(routeUrl + AchievementUrls.getAllAchievements),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );

      List resData = jsonDecode(response.body);

      return resData.map((e) => Achievement.fromJson(e)).toList();
    } catch (error) {
      return Future.error(error);
    }
  }
}
