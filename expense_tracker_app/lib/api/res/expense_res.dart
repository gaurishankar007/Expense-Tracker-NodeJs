import 'package:json_annotation/json_annotation.dart';

part 'expense_res.g.dart';

@JsonSerializable()
class ExpenseData {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  int? amount;
  String? category;
  String? createdAt;

  ExpenseData({
    this.id,
    this.name,
    this.amount,
    this.category,
    this.createdAt,
  });

  factory ExpenseData.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDataToJson(this);
}

@JsonSerializable()
class ExpenseCategorized {
  @JsonKey(name: "_id")
  String? category;

  int? amount;

  ExpenseCategorized({
    this.category,
    this.amount,
  });

  factory ExpenseCategorized.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategorizedFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseCategorizedToJson(this);
}

@JsonSerializable()
class ExpenseDWM {
  String? profilePicture;
  String? firstExpenseDate;
  List<ExpenseData>? todayExpenses;
  List<ExpenseData>? thisWeekExpenses;
  List<ExpenseData>? thisMonthExpenses;
  int? todayExpenseAmount;
  int? thisWeekExpenseAmount;
  int? thisMonthExpenseAmount;
  List<ExpenseCategorized>? todayExpenseCategories;
  List<ExpenseCategorized>? thisWeekExpenseCategories;
  List<ExpenseCategorized>? thisMonthExpenseCategories;

  ExpenseDWM({
    this.profilePicture,
    this.firstExpenseDate,
    this.todayExpenses,
    this.thisWeekExpenses,
    this.thisMonthExpenses,
    this.todayExpenseAmount,
    this.thisWeekExpenseAmount,
    this.thisMonthExpenseAmount,
    this.todayExpenseCategories,
    this.thisWeekExpenseCategories,
    this.thisMonthExpenseCategories,
  });

  factory ExpenseDWM.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDWMFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDWMToJson(this);
}

@JsonSerializable()
class ExpenseSpecific {
  List<ExpenseData>? expenses;
  int? expenseAmount;
  List<ExpenseCategorized>? expenseCategories;

  ExpenseSpecific({
    this.expenses,
    this.expenseAmount,
    this.expenseCategories,
  });

  factory ExpenseSpecific.fromJson(Map<String, dynamic> json) =>
      _$ExpenseSpecificFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseSpecificToJson(this);
}
