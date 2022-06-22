import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../log_status.dart';
import '../model/expense_income_model.dart';
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
}
