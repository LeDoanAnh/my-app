import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/usecases/actor_use_case.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/ui/user/actor_list/actor_list_event.dart';
import 'package:my_app/ui/user/actor_list/actor_list_state.dart';

class ActorListBloc extends Bloc<ActorListEvent, ActorListState> {
  final ActorUseCase actorUseCase;
  final DepartmentListUseCase departmentUseCase;

  ActorListBloc({required this.actorUseCase, required this.departmentUseCase})
    : super(ActorListInitial()) {
    on<GetActorListEvent>(_onGetActorList);
  }

  Future<void> _onGetActorList(
    GetActorListEvent event,
    Emitter<ActorListState> emit,
  ) async {
    if (state is! ActorListLoaded) {
      emit(ActorListLoading());
    }
    try {
      final actors = await actorUseCase.getActorList();
      final departments = await departmentUseCase.callResources();
      emit(ActorListLoaded(actors, departments));
    } catch (e) {
      emit(ActorListError("Lỗi tải dữ liệu danh sách đơn: ${e.toString()}"));
    }
  }
}
