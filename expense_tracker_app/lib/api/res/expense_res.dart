import 'package:json_annotation/json_annotation.dart';

part 'expense_res.g.dart';

@JsonSerializable()
class Expense {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  String? amount;
  String? category;
  String? createdAt;

  Expense({
    this.id,
    this.name,
    this.amount,
    this.category,
    this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}
