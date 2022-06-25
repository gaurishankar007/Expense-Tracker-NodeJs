// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseData _$ExpenseDataFromJson(Map<String, dynamic> json) => ExpenseData(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as int?,
      category: json['category'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ExpenseDataToJson(ExpenseData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'category': instance.category,
      'createdAt': instance.createdAt,
    };

ExpenseCategorized _$ExpenseCategorizedFromJson(Map<String, dynamic> json) =>
    ExpenseCategorized(
      category: json['_id'] as String?,
      amount: json['amount'] as int?,
    );

Map<String, dynamic> _$ExpenseCategorizedToJson(ExpenseCategorized instance) =>
    <String, dynamic>{
      '_id': instance.category,
      'amount': instance.amount,
    };

ExpenseDWM _$ExpenseDWMFromJson(Map<String, dynamic> json) => ExpenseDWM(
      profilePicture: json['profilePicture'] as String?,
      firstExpenseDate: json['firstExpenseDate'] as String?,
      todayExpenses: (json['todayExpenses'] as List<dynamic>?)
          ?.map((e) => ExpenseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeekExpenses: (json['thisWeekExpenses'] as List<dynamic>?)
          ?.map((e) => ExpenseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthExpenses: (json['thisMonthExpenses'] as List<dynamic>?)
          ?.map((e) => ExpenseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayExpenseAmount: json['todayExpenseAmount'] as int?,
      thisWeekExpenseAmount: json['thisWeekExpenseAmount'] as int?,
      thisMonthExpenseAmount: json['thisMonthExpenseAmount'] as int?,
      todayExpenseCategories: (json['todayExpenseCategories'] as List<dynamic>?)
          ?.map((e) => ExpenseCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeekExpenseCategories: (json['thisWeekExpenseCategories']
              as List<dynamic>?)
          ?.map((e) => ExpenseCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthExpenseCategories: (json['thisMonthExpenseCategories']
              as List<dynamic>?)
          ?.map((e) => ExpenseCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpenseDWMToJson(ExpenseDWM instance) =>
    <String, dynamic>{
      'profilePicture': instance.profilePicture,
      'firstExpenseDate': instance.firstExpenseDate,
      'todayExpenses': instance.todayExpenses,
      'thisWeekExpenses': instance.thisWeekExpenses,
      'thisMonthExpenses': instance.thisMonthExpenses,
      'todayExpenseAmount': instance.todayExpenseAmount,
      'thisWeekExpenseAmount': instance.thisWeekExpenseAmount,
      'thisMonthExpenseAmount': instance.thisMonthExpenseAmount,
      'todayExpenseCategories': instance.todayExpenseCategories,
      'thisWeekExpenseCategories': instance.thisWeekExpenseCategories,
      'thisMonthExpenseCategories': instance.thisMonthExpenseCategories,
    };

ExpenseSpecific _$ExpenseSpecificFromJson(Map<String, dynamic> json) =>
    ExpenseSpecific(
      expenses: (json['expenses'] as List<dynamic>?)
          ?.map((e) => ExpenseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      expenseAmount: json['expenseAmount'] as int?,
      expenseCategories: (json['expenseCategories'] as List<dynamic>?)
          ?.map((e) => ExpenseCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExpenseSpecificToJson(ExpenseSpecific instance) =>
    <String, dynamic>{
      'expenses': instance.expenses,
      'expenseAmount': instance.expenseAmount,
      'expenseCategories': instance.expenseCategories,
    };
