import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:jacobspears/app/model/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_in_result.g.dart';

@immutable
@JsonSerializable()
class CheckInResult extends Equatable {

  @JsonKey(name: "checkin_dates")
  final List<double> checkInTimestamps;

  @JsonKey(name: "point")
  final Point point;

  CheckInResult({
    this.checkInTimestamps,
    this.point
});


  @override
  // TODO: implement props
  List<Object> get props => [checkInTimestamps, point];

  factory CheckInResult.fromJson(Map<String, dynamic> json) => _$CheckInResultFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInResultToJson(this);

}