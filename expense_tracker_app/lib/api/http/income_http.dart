import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../model/expense_income_model.dart';
import '../res/income_res.dart';
import '../urls.dart';

class IncomeHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> addIncome(AddExpenseIncome incomeDetail) async {
    Map<String, String> incomeData = {
      "name": incomeDetail.name!,
      "amount": incomeDetail.amount!,
      "category": incomeDetail.category!,
    };
    final response = await post(
      Uri.parse(routeUrl + "income/add"),
      body: incomeData,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<IncomeDWM> getIncomeDWM() async {
    final response = await get(
      Uri.parse(routeUrl + "income/getDWM"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final resData = jsonDecode(response.body);

    return IncomeDWM.fromJson(resData);
  }

  Future<IncomeSpecific> getIncomeSpecific(
      String startDate, String endDate) async {
    final response = await post(
      Uri.parse(routeUrl + "income/getSpecific"),
      body: {"startDate": startDate, "endDate": endDate},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final resData = jsonDecode(response.body);

    return IncomeSpecific.fromJson(resData);
  }
}
