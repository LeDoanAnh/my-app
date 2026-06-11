abstract class UserDetailEvent {}

class GetUserDetail extends UserDetailEvent {
  final int userId;
  GetUserDetail(this.userId);
}

class DeactivateUser extends UserDetailEvent {
  final int userId;
  DeactivateUser(this.userId);
}
