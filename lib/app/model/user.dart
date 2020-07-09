import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
class User extends Equatable {

  @JsonKey(name: "id")
  final String uuid;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "first_name")
  final String firstName;

  @JsonKey(name: "last_name")
  final String lastName;

  @JsonKey(name: "is_active")
  final bool isActive;

  @JsonKey(name: "password")
  final String password;

  User({
    this.uuid,
    this.email,
    this.firstName,
    this.lastName,
    this.isActive,
    this.password
  });

  @override
  List<Object> get props => [uuid, email, firstName, lastName, isActive, password];

  @override
  bool get stringify => true;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}