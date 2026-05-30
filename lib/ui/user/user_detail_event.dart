abstract class UserDetailEvent {}

class GetUserDetail extends UserDetailEvent {
  final int userId;
  GetUserDetail(this.userId);
}
