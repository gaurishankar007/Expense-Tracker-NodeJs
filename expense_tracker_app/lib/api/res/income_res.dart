import 'package:json_annotation/json_annotation.dart';

part 'income_res.g.dart';

@JsonSerializable()
class IncomeData {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  int? amount;
  String? category;
  String? createdAt;

  IncomeData({
    this.id,
    this.name,
    this.amount,
    this.category,
  });

  factory IncomeData.fromJson(Map<String, dynamic> json) =>
      _$IncomeDataFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeDataToJson(this);
}

@JsonSerializable()
class IncomeCategorized {
  @JsonKey(name: "_id")
  String? category;

  int? amount;

  IncomeCategorized({
    this.category,
    this.amount,
  });

  factory IncomeCategorized.fromJson(Map<String, dynamic> json) =>
      _$IncomeCategorizedFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeCategorizedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class IncomeDWM {
  String? profilePicture;
  String? firstIncomeDate;
  List<IncomeData>? todayIncomes;
  List<IncomeData>? thisWeekIncomes;
  List<IncomeData>? thisMonthIncomes;
  int? todayIncomeAmount;
  int? thisWeekIncomeAmount;
  int? thisMonthIncomeAmount;
  List<IncomeCategorized>? todayIncomeCategories;
  List<IncomeCategorized>? thisWeekIncomeCategories;
  List<IncomeCategorized>? thisMonthIncomeCategories;

  IncomeDWM({
    this.profilePicture,
    this.firstIncomeDate,
    this.todayIncomes,
    this.thisWeekIncomes,
    this.thisMonthIncomes,
    this.todayIncomeAmount,
    this.thisWeekIncomeAmount,
    this.thisMonthIncomeAmount,
    this.todayIncomeCategories,
    this.thisWeekIncomeCategories,
    this.thisMonthIncomeCategories,
  });

  factory IncomeDWM.fromJson(Map<String, dynamic> json) =>
      _$IncomeDWMFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeDWMToJson(this);
}

@JsonSerializable()
class IncomeSpecific {
  List<IncomeData>? incomes;
  int? incomeAmount;
  List<IncomeCategorized>? incomeCategories;

  IncomeSpecific({
    this.incomes,
    this.incomeAmount,
    this.incomeCategories,
  });

  factory IncomeSpecific.fromJson(Map<String, dynamic> json) =>
      _$IncomeSpecificFromJson(json);

  Map<String, dynamic> toJson() => _$IncomeSpecificToJson(this);
}
