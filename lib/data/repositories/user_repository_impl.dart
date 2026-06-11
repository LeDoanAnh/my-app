import 'package:dio/dio.dart';
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/api/global_data.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/role_model.dart';
import 'package:my_app/data/model/user_model.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AuthApi _authApi;

  UserRepositoryImpl(this._authApi);

  @override
  Future<CreateResponse> createUser(Map<String, dynamic> body) async {
    try {
      return await _authApi.createUser(body);
    } on DioException catch (e) {
      _logDioError(e, body);
      throw Exception(_readDioErrorMessage(e));
    }
  }

  @override
  Future<CreateResponse> updateUser(int id, Map<String, dynamic> body) async {
    try {
      return await _authApi.updateUser(id, body);
    } on DioException catch (e) {
      _logDioError(e, body);
      throw Exception(_readDioErrorMessage(e));
    }
  }

  @override
  Future<CreateResponse> deactivateUser(int id) async {
    return await _authApi.deactivateUser(id);
  }

  @override
  Future<List<RoleEntity>> getRoleList() async {
    try {
      final RoleResponseModel models = await _authApi.getRoleList();
      return models.data!.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception("Lấy danh sách đơn thất bại: ${e.toString()}");
    }
  }

  @override
  Future<UserEntity> getUserDetail(int userId) async {
    try {
      final UserResponse response = await _authApi.getActorDetail(userId);
      return response.data!.toEntity();
    } catch (e) {
      throw Exception("Lấy thông tin người dùng thất bại: ${e.toString()}");
    }
  }

  void _logDioError(DioException e, Map<String, dynamic> body) {
    talker.error(
      'USER API ERROR\n'
      'ENDPOINT: ${e.requestOptions.method} ${e.requestOptions.uri}\n'
      'HEADERS: ${e.requestOptions.headers}\n'
      'REQUEST BODY: $body\n'
      'STATUS: ${e.response?.statusCode}\n'
      'RESPONSE BODY: ${e.response?.data}',
    );
  }

  String _readDioErrorMessage(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      final errors = data['errors'];
      final errorText = _formatValidationErrors(errors);

      if (message != null && message.isNotEmpty && errorText.isNotEmpty) {
        return '$message: $errorText';
      }
      if (message != null && message.isNotEmpty) {
        return message;
      }
      if (errorText.isNotEmpty) {
        return errorText;
      }
    }

    return e.message ?? 'Không thể thực hiện yêu cầu';
  }

  String _formatValidationErrors(dynamic errors) {
    if (errors is! Map) return '';

    return errors.entries
        .map((entry) {
          final value = entry.value;
          if (value is List) {
            return '${entry.key}: ${value.join(', ')}';
          }
          return '${entry.key}: $value';
        })
        .join('; ');
  }
}
