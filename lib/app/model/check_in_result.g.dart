// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_in_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInResult _$CheckInResultFromJson(Map<String, dynamic> json) {
  return CheckInResult(
    checkInTimestamps:  (json['checkin_dates'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList(),
    point: json['point'] == null
        ? null
        : Point.fromJson(json['point'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CheckInResultToJson(CheckInResult instance) =>
    <String, dynamic>{
      'checkin_dates': instance.checkInTimestamps,
      'point': instance.point,
    };
