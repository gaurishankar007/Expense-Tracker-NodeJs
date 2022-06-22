import 'package:json_annotation/json_annotation.dart';

part 'income_res.g.dart';

@JsonSerializable()
class Income {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  String? amount;
  String? category;
  String? createdAt;

  Income({
    this.id,
    this.name,
    this.amount,
    this.category,
  });

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeToJson(this);
}
