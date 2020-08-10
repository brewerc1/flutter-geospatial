// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return Settings(
    allowPhotos: json['allow_photos'] as bool,
    incidentTypes: (json['incident_types'] as List)
        ?.map((e) =>
    e == null ? null : IncidentType.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'allow_photos': instance.allowPhotos,
  'incident_types': instance.incidentTypes,
};