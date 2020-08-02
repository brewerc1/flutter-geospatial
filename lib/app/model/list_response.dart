import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

@immutable
@JsonSerializable()
class ListResponse extends Equatable {

  @JsonKey(name: "count")
  final int count;
  @JsonKey(name: "next")
  final String nextUri;
  @JsonKey(name: "previous")
  final String previousUri;
  @JsonKey(name: "results")
  final List results;

  ListResponse({
    this.count,
    this.nextUri,
    this.previousUri,
    this.results
  });

  @override
  List<Object> get props => throw UnimplementedError();

}