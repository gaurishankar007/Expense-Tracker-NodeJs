// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      thisMonthExpenses: (json['thisMonthExpenses'] as List<dynamic>?)
          ?.map((e) => ExpenseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthIncomes: (json['thisMonthIncomes'] as List<dynamic>?)
          ?.map((e) => IncomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthExpenseAmount: json['thisMonthExpenseAmount'] as int?,
      thisMonthIncomeAmount: json['thisMonthIncomeAmount'] as int?,
      maxExpenseCategory: json['maxExpenseCategory'] == null
          ? null
          : ExpenseCategorized.fromJson(
              json['maxExpenseCategory'] as Map<String, dynamic>),
      maxIncomeCategory: json['maxIncomeCategory'] == null
          ? null
          : ExpenseCategorized.fromJson(
              json['maxIncomeCategory'] as Map<String, dynamic>),
      previousMonthExpenseAmount: json['previousMonthExpenseAmount'] as int?,
      previousMonthIncomeAmount: json['previousMonthIncomeAmount'] as int?,
      thisMonthExpenseRate: (json['thisMonthExpenseRate'] as num?)?.toDouble(),
      thisMonthIncomeRate: (json['thisMonthIncomeRate'] as num?)?.toDouble(),
      previousMonthExpenseRate:
          (json['previousMonthExpenseRate'] as num?)?.toDouble(),
      previousMonthIncomeRate:
          (json['previousMonthIncomeRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'thisMonthExpenses': instance.thisMonthExpenses,
      'thisMonthIncomes': instance.thisMonthIncomes,
      'thisMonthExpenseAmount': instance.thisMonthExpenseAmount,
      'thisMonthIncomeAmount': instance.thisMonthIncomeAmount,
      'maxExpenseCategory': instance.maxExpenseCategory,
      'maxIncomeCategory': instance.maxIncomeCategory,
      'previousMonthExpenseAmount': instance.previousMonthExpenseAmount,
      'previousMonthIncomeAmount': instance.previousMonthIncomeAmount,
      'thisMonthExpenseRate': instance.thisMonthExpenseRate,
      'thisMonthIncomeRate': instance.thisMonthIncomeRate,
      'previousMonthExpenseRate': instance.previousMonthExpenseRate,
      'previousMonthIncomeRate': instance.previousMonthIncomeRate,
    };
