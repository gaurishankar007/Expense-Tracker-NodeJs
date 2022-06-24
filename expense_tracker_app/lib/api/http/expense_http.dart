import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/api/res/expense_res.dart';
import 'package:http/http.dart';

import '../log_status.dart';
import '../model/expense_income_model.dart';
import '../urls.dart';

class ExpenseHttp {
  final routeUrl = ApiUrls.routeUrl;
  final token = LogStatus.token;

  Future<Map> addExpense(AddExpenseIncome expenseDetail) async {
    Map<String, String> expenseData = {
      "name": expenseDetail.name!,
      "amount": expenseDetail.amount!,
      "category": expenseDetail.category!,
    };

    final response = await post(
      Uri.parse(routeUrl + "expense/add"),
      body: expenseData,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<ExpenseDWM> getExpenseDWM() async {
    final response = await get(
      Uri.parse(routeUrl + "expense/getDWM"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final resData = jsonDecode(response.body);

    return ExpenseDWM.fromJson(resData);
  }

  Future<ExpenseSpecific> getExpenseSpecific(
      String startDate, String endDate) async {
    final response = await post(
      Uri.parse(routeUrl + "expense/getSpecific"),
      body: {"startDate": startDate, "endDate": endDate},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    final resData = jsonDecode(response.body);

    return ExpenseSpecific.fromJson(resData);
  }
}
