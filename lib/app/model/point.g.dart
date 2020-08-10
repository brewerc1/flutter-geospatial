// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Point _$PointFromJson(Map<String, dynamic> json) {
  return Point(
    uuid: json['id'] as String,
    name: json['name'] as String,
    iconName: json['icon'] as String,
    description: json['description'] as String,
    geometry: json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    segments: (json['segments'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
      'id': instance.uuid,
      'name': instance.name,
      'description': instance.description,
      'geometry': instance.geometry,
      'segments': instance.segments,
      'icon': instance.iconName,
    };
