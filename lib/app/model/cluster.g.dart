// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cluster _$ClusterFromJson(Map<String, dynamic> json) {
  return Cluster(
    uuid: json['id'] as String,
    name: json['name'] as String,
    segmants: (json['segments'] as List)
        ?.map((e) =>
            e == null ? null : Segment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    relatedPoints: (json['related_points'] as List)
        ?.map(
            (e) => e == null ? null : Point.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    incidentTypes: (json['incident_types'] as List)
        ?.map((e) =>
            e == null ? null : IncidentType.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ClusterToJson(Cluster instance) => <String, dynamic>{
      'id': instance.uuid,
      'name': instance.name,
      'segments': instance.segmants,
      'related_points': instance.relatedPoints,
      'incident_types': instance.incidentTypes,
    };
