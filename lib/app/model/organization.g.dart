// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organization _$OrganizationFromJson(Map<String, dynamic> json) {
  return Organization(
    uuid: json['id'] as String,
    name: json['name'] as String,
    externalId: json['external_id'] as String,
  );
}

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.uuid,
      'name': instance.name,
      'external_id': instance.externalId,
    };
