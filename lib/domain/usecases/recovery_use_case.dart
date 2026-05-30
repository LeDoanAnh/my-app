import 'package:my_app/domain/entities/recovery_entity.dart';
import 'package:my_app/domain/repositories/recovery_repository.dart';

class RecoveryUseCase {
  final RecoveryRepository repository;
  RecoveryUseCase({required this.repository});

  Future<List<RecoveryEntity>> getRecoveryList(
    int handlerId, {
    String? search,
  }) => repository.getRecoveryList(handlerId, search: search);

  Future<RecoveryActionResponse> confirmRecovery(
    int submissionId,
    int handlerId,
  ) => repository.confirmRecovery(submissionId, handlerId);

  Future<RecoveryActionResponse> remindReturn(
    int submissionId,
    int handlerId,
  ) => repository.remindReturn(submissionId, handlerId);
}
