import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geometry.g.dart';

@immutable
@JsonSerializable()
class Geometry extends Equatable {

  @JsonKey(name: "type")
  final String type;

  @JsonKey(name: "coordinates")
  final List<double> coordinates;

  Geometry({
    this.type,
    this.coordinates
  });

  @override
  List<Object> get props => [type, coordinates];

  @override
  bool get stringify => true;

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}