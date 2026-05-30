import 'package:json_annotation/json_annotation.dart';
part 'search_model.g.dart';

@JsonSerializable()
class SearchResultModel {
  final int? id;
  final String? title;
  final String? category;
  final String? status;
  @JsonKey(name: 'ref_id')
  final int? refId;

  SearchResultModel({
    this.id,
    this.title,
    this.category,
    this.status,
    this.refId,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}

@JsonSerializable()
class SearchListResponse {
  final bool? success;
  final List<SearchResultModel>? data;

  SearchListResponse({this.success, this.data});

  factory SearchListResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SearchListResponseToJson(this);
}
