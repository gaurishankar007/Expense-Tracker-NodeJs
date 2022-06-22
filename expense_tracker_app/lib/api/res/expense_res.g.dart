// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as String?,
      category: json['category'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'category': instance.category,
      'createdAt': instance.createdAt,
    };
