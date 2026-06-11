import 'package:my_app/data/model/create_user_params.dart';

abstract class CreateUserEvent {}

class SubmitCreateUser extends CreateUserEvent {
  final int? userId;
  final CreateUserParams params;
  SubmitCreateUser(this.params, {this.userId});
}

class GetRoleList extends CreateUserEvent {
  GetRoleList();
}
