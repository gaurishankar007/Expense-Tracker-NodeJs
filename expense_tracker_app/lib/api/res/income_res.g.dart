// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Income _$IncomeFromJson(Map<String, dynamic> json) => Income(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      amount: json['amount'] as String?,
      category: json['category'] as String?,
    )..createdAt = json['createdAt'] as String?;

Map<String, dynamic> _$IncomeToJson(Income instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'category': instance.category,
      'createdAt': instance.createdAt,
    };
