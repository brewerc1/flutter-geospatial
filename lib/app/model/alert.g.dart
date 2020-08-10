// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return Alert(
    uuid: json['id'] as String,
    title: json['title'] as String,
    timeStamp: json['created_timestamp'] as double,
    isActive: json['is_active'] as bool,
    iconName: json['icon'] as String,
    description: json['description'] as String,
    geometry: json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AlertToJson(Alert instance) => <String, dynamic>{
  'id': instance.uuid,
  'icon': instance.iconName,
  'description': instance.description,
  'geometry': instance.geometry,
  'title': instance.title,
  'created_timestamp': instance.timeStamp,
  'is_active': instance.isActive,
};
