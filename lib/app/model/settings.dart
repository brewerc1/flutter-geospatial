import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jacobspears/app/model/incident_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@immutable
@JsonSerializable()
class Settings extends Equatable {

  @JsonKey(name: "allow_photos")
  final bool allowPhotos;

  @JsonKey(name: "incident_types")
  final List<IncidentType> incidentTypes;

  Settings({
    this.allowPhotos,
    this.incidentTypes
  });

  @override
  List<Object> get props => [allowPhotos, incidentTypes,];

  @override
  bool get stringify => true;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}