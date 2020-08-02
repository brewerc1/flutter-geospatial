import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_exception.g.dart';

@immutable
@JsonSerializable()
class APIException {
  @JsonKey(name: "detail")
  final String message;

  APIException(
      this.message,
      );

  factory APIException.fromJson(Map<String, dynamic> json) => _$APIExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$APIExceptionToJson(this);
}

@immutable
@JsonSerializable()
class APIExceptionReason {
  @JsonKey(name: "detail")
  final String message;

  APIExceptionReason(
      this.message,
      );

  factory APIExceptionReason.fromJson(Map<String, dynamic> json) => _$APIExceptionReasonFromJson(json);

  Map<String, dynamic> toJson() => _$APIExceptionReasonToJson(this);
}