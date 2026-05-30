import 'package:json_annotation/json_annotation.dart';
part 'create_response.g.dart';

@JsonSerializable()
class CreateResponse{
  final bool success;
  final String message;

  CreateResponse({
    required this.success,
    required this.message,
  });
  factory CreateResponse.fromJson(Map<String, dynamic> json) => _$CreateResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateResponseToJson(this);
}