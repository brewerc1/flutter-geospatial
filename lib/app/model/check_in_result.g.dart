// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInResult _$CheckInResultFromJson(Map<String, dynamic> json) {
  return CheckInResult(
    uuid: json['id'] as String,
    point: json['point'] == null
        ? null
        : Point.fromJson(json['point'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CheckInResultToJson(CheckInResult instance) =>
    <String, dynamic>{
      'id': instance.uuid,
      'point': instance.point,
    };
