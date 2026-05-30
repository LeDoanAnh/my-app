import 'package:my_app/domain/entities/recovery_entity.dart';

abstract class RecoveryRepository {
  Future<List<RecoveryEntity>> getRecoveryList(int handlerId, {String? search});
  Future<RecoveryActionResponse> confirmRecovery(int submissionId, int handlerId);
  Future<RecoveryActionResponse> remindReturn(int submissionId, int handlerId);
}

class RecoveryActionResponse {
  final bool success;
  final String message;
  RecoveryActionResponse({required this.success, required this.message});
}