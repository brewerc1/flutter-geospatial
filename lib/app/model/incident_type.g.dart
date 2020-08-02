// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentType _$IncidentTypeFromJson(Map<String, dynamic> json) {
  return IncidentType(
    uuid: json['id'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$IncidentTypeToJson(IncidentType instance) =>
    <String, dynamic>{
      'id': instance.uuid,
      'title': instance.title,
    };
