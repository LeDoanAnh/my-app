abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class GetHomeDataEvent extends HomeEvent {
  final int userId;

  GetHomeDataEvent({required this.userId});
}

class RefreshHomeDataEvent extends HomeEvent {
  final int userId;

  RefreshHomeDataEvent({required this.userId});
}
