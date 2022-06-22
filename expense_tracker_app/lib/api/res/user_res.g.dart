// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      profileName: json['profileName'] as String?,
      profilePicture: json['profilePicture'] as String?,
      gender: json['gender'] as String?,
      progressPublication: json['progressPublication'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'profileName': instance.profileName,
      'profilePicture': instance.profilePicture,
      'gender': instance.gender,
      'progressPublication': instance.progressPublication,
    };
