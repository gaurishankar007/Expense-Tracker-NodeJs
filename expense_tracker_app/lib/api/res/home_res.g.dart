// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      expenseDays: (json['expenseDays'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      expenseAmounts: (json['expenseAmounts'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      maxExpenseAmount: json['maxExpenseAmount'] as int?,
      thisMonthExpenseCategories: (json['thisMonthExpenseCategories']
              as List<dynamic>?)
          ?.map((e) => ExpenseCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthIncomeCategories: (json['thisMonthIncomeCategories']
              as List<dynamic>?)
          ?.map((e) => IncomeCategorized.fromJson(e as Map<String, dynamic>))
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
      'expenseDays': instance.expenseDays,
      'expenseAmounts': instance.expenseAmounts,
      'maxExpenseAmount': instance.maxExpenseAmount,
      'thisMonthExpenseCategories': instance.thisMonthExpenseCategories,
      'thisMonthIncomeCategories': instance.thisMonthIncomeCategories,
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
