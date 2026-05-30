import 'package:my_app/data/model/create_user_params.dart';
import 'package:my_app/domain/entities/role_entity.dart';
import 'package:my_app/domain/usecases/create_user_use_case.dart';

abstract class CreateUserEvent {}

class SubmitCreateUser extends CreateUserEvent {
  final CreateUserParams params;
  SubmitCreateUser(this.params);
}

class GetRoleList extends CreateUserEvent {
  GetRoleList();
}
