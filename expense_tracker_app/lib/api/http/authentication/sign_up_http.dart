import 'dart:convert';
import 'package:http/http.dart';

import '../../log_status.dart';
import '../../model/user_model.dart';
import '../../urls.dart';

class SignUpHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> signUp(UploadUser userDetails) async {
    try {
      Map<String, String> userData = {
        "email": userDetails.email!,
        "password": userDetails.password!,
        "confirmPassword": userDetails.confirmPassword!,
        "profileName": userDetails.profileName!,
      };

      final response =
          await post(Uri.parse(routeUrl + "user/register"), body: userData);
      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body) as Map,
      };
    } catch (error) {
      return Future.error(error);
    }
  }
}
