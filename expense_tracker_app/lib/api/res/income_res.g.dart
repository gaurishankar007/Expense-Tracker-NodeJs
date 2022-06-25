// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeData _$IncomeDataFromJson(Map<String, dynamic> json) => IncomeData(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as int?,
      category: json['category'] as String?,
    )..createdAt = json['createdAt'] as String?;

Map<String, dynamic> _$IncomeDataToJson(IncomeData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'category': instance.category,
      'createdAt': instance.createdAt,
    };

IncomeCategorized _$IncomeCategorizedFromJson(Map<String, dynamic> json) =>
    IncomeCategorized(
      category: json['_id'] as String?,
      amount: json['amount'] as int?,
    );

Map<String, dynamic> _$IncomeCategorizedToJson(IncomeCategorized instance) =>
    <String, dynamic>{
      '_id': instance.category,
      'amount': instance.amount,
    };

IncomeDWM _$IncomeDWMFromJson(Map<String, dynamic> json) => IncomeDWM(
      profilePicture: json['profilePicture'] as String?,
      firstIncomeDate: json['firstIncomeDate'] as String?,
      todayIncomes: (json['todayIncomes'] as List<dynamic>?)
          ?.map((e) => IncomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeekIncomes: (json['thisWeekIncomes'] as List<dynamic>?)
          ?.map((e) => IncomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthIncomes: (json['thisMonthIncomes'] as List<dynamic>?)
          ?.map((e) => IncomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      todayIncomeAmount: json['todayIncomeAmount'] as int?,
      thisWeekIncomeAmount: json['thisWeekIncomeAmount'] as int?,
      thisMonthIncomeAmount: json['thisMonthIncomeAmount'] as int?,
      todayIncomeCategories: (json['todayIncomeCategories'] as List<dynamic>?)
          ?.map((e) => IncomeCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisWeekIncomeCategories: (json['thisWeekIncomeCategories']
              as List<dynamic>?)
          ?.map((e) => IncomeCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
      thisMonthIncomeCategories: (json['thisMonthIncomeCategories']
              as List<dynamic>?)
          ?.map((e) => IncomeCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IncomeDWMToJson(IncomeDWM instance) => <String, dynamic>{
      'profilePicture': instance.profilePicture,
      'firstIncomeDate': instance.firstIncomeDate,
      'todayIncomes': instance.todayIncomes?.map((e) => e.toJson()).toList(),
      'thisWeekIncomes':
          instance.thisWeekIncomes?.map((e) => e.toJson()).toList(),
      'thisMonthIncomes':
          instance.thisMonthIncomes?.map((e) => e.toJson()).toList(),
      'todayIncomeAmount': instance.todayIncomeAmount,
      'thisWeekIncomeAmount': instance.thisWeekIncomeAmount,
      'thisMonthIncomeAmount': instance.thisMonthIncomeAmount,
      'todayIncomeCategories':
          instance.todayIncomeCategories?.map((e) => e.toJson()).toList(),
      'thisWeekIncomeCategories':
          instance.thisWeekIncomeCategories?.map((e) => e.toJson()).toList(),
      'thisMonthIncomeCategories':
          instance.thisMonthIncomeCategories?.map((e) => e.toJson()).toList(),
    };

IncomeSpecific _$IncomeSpecificFromJson(Map<String, dynamic> json) =>
    IncomeSpecific(
      incomes: (json['incomes'] as List<dynamic>?)
          ?.map((e) => IncomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      incomeAmount: json['incomeAmount'] as int?,
      incomeCategories: (json['incomeCategories'] as List<dynamic>?)
          ?.map((e) => IncomeCategorized.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$IncomeSpecificToJson(IncomeSpecific instance) =>
    <String, dynamic>{
      'incomes': instance.incomes,
      'incomeAmount': instance.incomeAmount,
      'incomeCategories': instance.incomeCategories,
    };
