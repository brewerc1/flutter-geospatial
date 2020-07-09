import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@immutable
@JsonSerializable()
class Organization extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "name")
  final String name;


  @JsonKey(name: "external_id")
  final String externalId;

  Organization({
    this.uuid,
    this.name,
    this.externalId
  });

  @override
  List<Object> get props => [uuid, name, externalId];

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}