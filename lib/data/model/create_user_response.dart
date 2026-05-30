import 'package:json_annotation/json_annotation.dart';

part 'create_user_response.g.dart';

@JsonSerializable()
class CreateUserResponse {
  final bool success;
  final String message;

  CreateUserResponse({
    required this.success,
    required this.message,
  });

  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserResponseToJson(this);
}