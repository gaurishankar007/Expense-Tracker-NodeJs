import 'package:expense_tracker/api/res/expense_res.dart';
import 'package:expense_tracker/api/res/income_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_res.g.dart';

@JsonSerializable()
class HomeData {
  bool? thisMonthView;
  List<int>? expenseDays;
  List<int>? expenseAmounts;
  int? maxExpenseAmount;
  List<ExpenseCategorized>? thisMonthExpenseCategories;
  List<IncomeCategorized>? thisMonthIncomeCategories;
  int? thisMonthExpenseAmount;
  int? thisMonthIncomeAmount;
  int? previousMonthExpenseAmount;
  int? previousMonthIncomeAmount;
  double? thisMonthExpenseRate;
  double? thisMonthIncomeRate;
  double? previousMonthExpenseRate;
  double? previousMonthIncomeRate;

  HomeData({
    this.thisMonthView,
    this.expenseDays,
    this.expenseAmounts,
    this.maxExpenseAmount,
    this.thisMonthExpenseCategories,
    this.thisMonthIncomeCategories,
    this.thisMonthExpenseAmount,
    this.thisMonthIncomeAmount,
    this.previousMonthExpenseAmount,
    this.previousMonthIncomeAmount,
    this.thisMonthExpenseRate,
    this.thisMonthIncomeRate,
    this.previousMonthExpenseRate,
    this.previousMonthIncomeRate,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) =>
      _$HomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}
