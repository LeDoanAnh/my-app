import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/submission_stats_entity.dart';
import 'package:my_app/domain/usecases/home_usecase.dart';
import 'package:my_app/ui/home/home_event.dart';
import 'package:my_app/ui/home/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeUseCase homeUseCase;

  HomeBloc({required this.homeUseCase}) : super(HomeInitial()) {
    on<GetHomeDataEvent>(_onGetHomeData);
    on<RefreshHomeDataEvent>(_onGetHomeData);
  }

  Future<void> _onGetHomeData(HomeEvent event, Emitter<HomeState> emit) async {
    final int userId;
    if (event is GetHomeDataEvent) {
      userId = event.userId;
      if (state is! HomeLoaded) {
        emit(HomeLoading());
      }
    } else if (event is RefreshHomeDataEvent) {
      userId = event.userId;
    } else {
      return;
    }
    try {
      final results = await Future.wait([
        homeUseCase.getStats(userId),
        homeUseCase.getRecent(userId),
      ]);
      final stats = results[0] as SubmissionStatsEntity;
      final recent = results[1] as List<SubmissionEntity>;

      emit(HomeLoaded(stats: stats, recentSubmissions: recent));
    } catch (e) {
      emit(HomeError("Lỗi tải dữ liệu trang chủ: ${e.toString()}"));
    }
  }
}
