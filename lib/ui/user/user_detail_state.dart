import 'package:my_app/domain/entities/user_entity.dart';

abstract class UserDetailState {}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final UserEntity user;
  UserDetailLoaded(this.user);
}

class UserDetailError extends UserDetailState {
  final String message;
  UserDetailError(this.message);
}
