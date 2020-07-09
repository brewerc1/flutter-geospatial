// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cluster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cluster _$ClusterFromJson(Map<String, dynamic> json) {
  return Cluster(
    uuid: json['id'] as String,
    name: json['name'] as String,
    relatedPoints:
        (json['related_points'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ClusterToJson(Cluster instance) => <String, dynamic>{
      'id': instance.uuid,
      'name': instance.name,
      'related_points': instance.relatedPoints,
    };
