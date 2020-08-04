// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Segment _$SegmentFromJson(Map<String, dynamic> json) {
  return Segment(
    uuid: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    points: (json['points'] as List)
        ?.map(
            (e) => e == null ? null : Point.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'id': instance.uuid,
      'name': instance.name,
      'description': instance.description,
      'points': instance.points,
    };
