// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
      name: json['name'] as String?,
      requiredProgressPoint: json['requiredProgressPoint'] as int?,
      description: json['description'] as String?,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'requiredProgressPoint': instance.requiredProgressPoint,
      'description': instance.description,
    };

Achievement _$AchievementFromJson(Map<String, dynamic> json) => Achievement(
      name: json['name'] as String?,
      progressPoint: json['progressPoint'] as int?,
      description: json['description'] as String?,
    )..id = json['_id'] as String?;

Map<String, dynamic> _$AchievementToJson(Achievement instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'progressPoint': instance.progressPoint,
      'description': instance.description,
    };

Progress _$ProgressFromJson(Map<String, dynamic> json) => Progress(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      progress: json['progress'] as int?,
      tmp: json['tmp'] as int?,
      pmp: json['pmp'] as int?,
      badge: json['badge'] == null
          ? null
          : Badge.fromJson(json['badge'] as Map<String, dynamic>),
      pMBadge: json['pMBadge'] == null
          ? null
          : Badge.fromJson(json['pMBadge'] as Map<String, dynamic>),
      oldAchievement: (json['oldAchievement'] as List<dynamic>?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      newAchievement: (json['newAchievement'] as List<dynamic>?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..id = json['_id'] as String?;

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      '_id': instance.id,
      'user': instance.user?.toJson(),
      'progress': instance.progress,
      'tmp': instance.tmp,
      'pmp': instance.pmp,
      'badge': instance.badge?.toJson(),
      'pMBadge': instance.pMBadge?.toJson(),
      'oldAchievement':
          instance.oldAchievement?.map((e) => e.toJson()).toList(),
      'newAchievement':
          instance.newAchievement?.map((e) => e.toJson()).toList(),
    };

ProgressData _$ProgressDataFromJson(Map<String, dynamic> json) => ProgressData(
      progress: json['progress'] == null
          ? null
          : Progress.fromJson(json['progress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProgressDataToJson(ProgressData instance) =>
    <String, dynamic>{
      'progress': instance.progress?.toJson(),
    };
