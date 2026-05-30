import 'package:my_app/domain/entities/recovery_entity.dart';

abstract class RecoveryState {}

class RecoveryInitial extends RecoveryState {}

class RecoveryLoading extends RecoveryState {}

class RecoveryLoaded extends RecoveryState {
  final List<RecoveryEntity> items;
  RecoveryLoaded(this.items);
}

class RecoveryActionSuccess extends RecoveryState {
  final String message;
  RecoveryActionSuccess(this.message);
}

class RecoveryError extends RecoveryState {
  final String message;
  RecoveryError(this.message);
}
