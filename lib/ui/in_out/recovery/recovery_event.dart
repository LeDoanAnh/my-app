abstract class RecoveryEvent {}

class LoadRecoveryList extends RecoveryEvent {
  final int handlerId;
  final String? search;
  LoadRecoveryList({required this.handlerId, this.search});
}

class ConfirmRecovery extends RecoveryEvent {
  final int submissionId;
  final int handlerId;
  ConfirmRecovery({required this.submissionId, required this.handlerId});
}

class RemindReturn extends RecoveryEvent {
  final int submissionId;
  final int handlerId;
  RemindReturn({required this.submissionId, required this.handlerId});
}
