// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uuid: json['id'] as String,
    email: json['email'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    isActive: json['is_active'] as bool,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.uuid,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_active': instance.isActive,
      'password': instance.password,
    };
