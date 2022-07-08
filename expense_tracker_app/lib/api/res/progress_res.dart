import 'package:expense_tracker/api/res/user_res.dart';
import 'package:json_annotation/json_annotation.dart';

part 'progress_res.g.dart';

@JsonSerializable()
class Badge {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  int? requiredProgressPoint;
  String? description;

  Badge({
    this.name,
    this.requiredProgressPoint,
    this.description,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}

@JsonSerializable()
class Achievement {
  @JsonKey(name: "_id")
  String? id;

  String? name;
  int? progressPoint;
  String? description;

  Achievement({
    this.name,
    this.progressPoint,
    this.description,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Progress {
  @JsonKey(name: "_id")
  String? id;

  User? user;
  int? progress;
  int? tmp;
  int? pmp;
  Badge? badge;
  Badge? pMBadge;
  List<Achievement>? oldAchievement;
  List<Achievement>? newAchievement;

  Progress({
    this.user,
    this.progress,
    this.tmp,
    this.pmp,
    this.badge,
    this.pMBadge,
    this.oldAchievement,
    this.newAchievement,
  });

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProgressData {
  Progress? progress;

  ProgressData({
    this.progress,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) =>
      _$ProgressDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressDataToJson(this);
}
