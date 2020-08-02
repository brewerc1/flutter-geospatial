// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIException _$APIExceptionFromJson(Map<String, dynamic> json) {
  return APIException(
    json['detail'] as String,
  );
}

Map<String, dynamic> _$APIExceptionToJson(APIException instance) =>
    <String, dynamic>{
      'detail': instance.message,
    };

APIExceptionReason _$APIExceptionReasonFromJson(Map<String, dynamic> json) {
  return APIExceptionReason(
    json['detail'] as String,
  );
}

Map<String, dynamic> _$APIExceptionReasonToJson(APIExceptionReason instance) =>
    <String, dynamic>{
      'detail': instance.message,
    };
