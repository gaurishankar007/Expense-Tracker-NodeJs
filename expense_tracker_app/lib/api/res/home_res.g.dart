// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      thisMonthView: json['thisMonthView'] as bool?,
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
      'thisMonthView': instance.thisMonthView,
      'expenseDays': instance.expenseDays,
      'expenseAmounts': instance.expenseAmounts,
      'maxExpenseAmount': instance.maxExpenseAmount,
      'thisMonthExpenseCategories': instance.thisMonthExpenseCategories,
      'thisMonthIncomeCategories': instance.thisMonthIncomeCategories,
      'thisMonthExpenseAmount': instance.thisMonthExpenseAmount,
      'thisMonthIncomeAmount': instance.thisMonthIncomeAmount,
      'previousMonthExpenseAmount': instance.previousMonthExpenseAmount,
      'previousMonthIncomeAmount': instance.previousMonthIncomeAmount,
      'thisMonthExpenseRate': instance.thisMonthExpenseRate,
      'thisMonthIncomeRate': instance.thisMonthIncomeRate,
      'previousMonthExpenseRate': instance.previousMonthExpenseRate,
      'previousMonthIncomeRate': instance.previousMonthIncomeRate,
    };
