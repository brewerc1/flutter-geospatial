import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cluster.g.dart';

@immutable
@JsonSerializable()
class Cluster extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "name")
  final String name;


  @JsonKey(name: "related_points")
  final List<String> relatedPoints;

  Cluster({
    this.uuid,
    this.name,
    this.relatedPoints
  });

  @override
  List<Object> get props => [uuid, name, relatedPoints];

  @override
  bool get stringify => true;

  factory Cluster.fromJson(Map<String, dynamic> json) => _$ClusterFromJson(json);

  Map<String, dynamic> toJson() => _$ClusterToJson(this);
}