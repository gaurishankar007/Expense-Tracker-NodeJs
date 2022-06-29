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

  Future<Map> removeExpense(String expenseId) async {
    final response = await delete(
      Uri.parse(routeUrl + "expense/remove"),
      body: {"expenseId": expenseId},
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return jsonDecode(response.body) as Map;
  }

  Future<Map> editExpense(ExpenseData expense) async {
    Map<String, String> expenseData = {
      "expenseId": expense.id!,
      "name": expense.name!,
      "amount": expense.amount!.toString(),
      "category": expense.category!,
    };

    final response = await put(
      Uri.parse(routeUrl + "expense/edit"),
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

  Future<List<ExpenseData>> getCategorizedExpense(String category) async {
    final response = await post(
      Uri.parse(routeUrl + "expense/categorized"),
      body: {
        "category": category,
      },
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resData = jsonDecode(response.body);

    return resData.map((e) => ExpenseData.fromJson(e)).toList();
  }

  Future<List<ExpenseData>> getCategorizedSpecificExpense(
      String category, String startDate, String endDate) async {
    Map<String, String> expenseData = {
      "startDate": startDate,
      "endDate": endDate,
      "category": category,
    };

    final response = await post(
      Uri.parse(routeUrl + "expense/categorizedSpecific"),
      body: expenseData,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    List resData = jsonDecode(response.body);

    return resData.map((e) => ExpenseData.fromJson(e)).toList();
  }

  Future<String> getCategoryStartDate(String category) async {
    final response = await post(
      Uri.parse(routeUrl + "expense/getCategoryStartDate"),
      body: {
        "category": category,
      },
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    return response.body;
  }
}
