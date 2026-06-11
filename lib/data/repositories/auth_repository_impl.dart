import 'dart:convert';
import 'package:hive_ce/hive.dart';
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/model/role_model.dart';
import 'package:my_app/data/model/user_model.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthApi api;
  String? _sessionId;
  AuthRepositoryImpl(this.api);

  Box<String> get _useBox => Hive.box<String>("user_box");

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final tokenRes = await api.getRequestToken();
      final requestToken = tokenRes["request_token"];
      await api.validateWithLogin({
        "username": username,
        "password": password,
        "request_token": requestToken,
      });

      final sessionRes = await api.createSession({
        "request_token": requestToken,
      });
      _sessionId = sessionRes["session_id"];

      final userModel = await api.getAccount(_sessionId!);
      final userEntity = userModel.toEntity().copyWith(sessionId: _sessionId);

      await saveUserToLocal(userEntity);
      return userEntity;
    } catch (e) {
      throw Exception("Đăng nhập thất bại: ${e.toString()}");
    }
  }

  @override
  Future<void> logout() async {
    _sessionId = null;
    await _useBox.delete("current_user");
  }

  @override
  Future<void> saveUserToLocal(UserEntity user) async {
    final userModel = UserModel(
      id: user.id,
      username: user.username,
      fullName: user.fullName,
      email: user.email,
      sessionId: user.sessionId,
      departmentId: user.departmentId,
      departmentName: user.departmentName,
      token: user.token,
      status: user.status,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      totalSubmissions: user.totalSubmissions,
      unreadNotifications: user.unreadNotifications,
      isFirstLogin: user.isFirstLogin,
      roles:
          user.roles
              ?.map(
                (e) => RoleModel(
                  id: e.id ?? 0,
                  roleName: e.roleName ?? "Không xác định",
                  description: e.description ?? "Không xác định",
                ),
              )
              .toList() ??
          [],
    );

    final String userJson = jsonEncode(userModel.toJson());
    await _useBox.put("current_user", userJson);
  }

  @override
  Future<UserEntity?> getUserFromLocal() async {
    if (!Hive.isBoxOpen("user_box")) {
      await Hive.openBox<String>("user_box");
    }

    final String? userJson = _useBox.get("current_user");
    if (userJson != null) {
      // Decode và chuyển đổi ngược lại Entity
      return UserModel.fromJson(jsonDecode(userJson)).toEntity();
    }
    return null;
  }

  @override
  Future<void> saveFcmToken(String token) async {
    try {
      String? tokenToUse = _sessionId;

      if (tokenToUse == null || tokenToUse.isEmpty) {
        final user = await getUserFromLocal();
        tokenToUse = user?.sessionId;
      }
      if (tokenToUse != null && tokenToUse.isNotEmpty) {
        await api.saveFcmToken("Bearer $tokenToUse", {"token": token});
      } else {
        print("Repository Error: Không tìm thấy Session ID để xác thực");
      }
    } catch (e) {
      print("Repository Error: Không thể lưu FCM Token: ${e.toString()}");
    }
  }

  @override
  Future<UserEntity> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      String? tokenToUse = _sessionId;

      if (tokenToUse == null || tokenToUse.isEmpty) {
        final user = await getUserFromLocal();
        tokenToUse = user?.sessionId;
      }

      if (tokenToUse == null || tokenToUse.isEmpty) {
        throw Exception("Không tìm thấy phiên đăng nhập");
      }

      await api.changePassword("Bearer $tokenToUse", {
        "current_password": currentPassword,
        "password": newPassword,
        "password_confirmation": newPasswordConfirmation,
      });

      final currentUser = await getUserFromLocal();
      if (currentUser == null) {
        throw Exception("Không tìm thấy thông tin người dùng");
      }

      final updatedUser = currentUser.copyWith(isFirstLogin: false);
      await saveUserToLocal(updatedUser);
      return updatedUser;
    } catch (e) {
      throw Exception("Đổi mật khẩu thất bại: ${e.toString()}");
    }
  }

  @override
  Future<void> forgotPassword(String identifier) async {
    try {
      await api.forgotPassword({"identifier": identifier});
    } catch (e) {
      throw Exception("Không thể gửi mật khẩu mới: ${e.toString()}");
    }
  }
}
