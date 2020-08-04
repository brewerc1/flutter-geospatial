// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Incident _$IncidentFromJson(Map<String, dynamic> json) {
  return Incident(
    uuid: json['id'] as String,
    typeUuid: json['type'] as String,
    photo: json['photos'] as String,
    description: json['description'] as String,
    geometry: json['geometry'] == null
        ? null
        : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
  'id': instance.uuid,
  'type': instance.typeUuid,
  'description': instance.description,
  'geometry': instance.geometry,
  'photos': instance.photo
};