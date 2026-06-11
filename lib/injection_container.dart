import 'package:get_it/get_it.dart';
import 'package:my_app/core/network/dio_client.dart';
import 'package:my_app/data/api/api.dart';
import 'package:my_app/data/repositories/actor_repository_impl.dart';
import 'package:my_app/data/repositories/approval_step_repository_impl.dart';
import 'package:my_app/data/repositories/approver_repository_impl.dart';
import 'package:my_app/data/repositories/asset_repository_impl.dart';
import 'package:my_app/data/repositories/asset_task_repository_impl.dart';
import 'package:my_app/data/repositories/auth_repository_impl.dart';
import 'package:my_app/data/repositories/borrow_repository_impl.dart';
import 'package:my_app/data/repositories/calendar_repository_impl.dart';
import 'package:my_app/data/repositories/department_repository_impl.dart';
import 'package:my_app/data/repositories/history_repository_impl.dart';
import 'package:my_app/data/repositories/home_repository_impl.dart';
import 'package:my_app/data/repositories/location_repository_impl.dart';
import 'package:my_app/data/repositories/notification_repository_impl.dart';
import 'package:my_app/data/repositories/recovery_repository_impl.dart';
import 'package:my_app/data/repositories/search_repository_impl.dart';
import 'package:my_app/data/repositories/submission_detail_impl.dart';
import 'package:my_app/data/repositories/submission_list_repository_impl.dart';
import 'package:my_app/data/repositories/submission_repository_impl.dart';
import 'package:my_app/data/repositories/user_repository_impl.dart';
import 'package:my_app/data/repositories/workflow_repository_impl.dart';
import 'package:my_app/domain/repositories/actor_repository.dart';
import 'package:my_app/domain/repositories/approval_step_repository.dart';
import 'package:my_app/domain/repositories/approver_repository.dart';
import 'package:my_app/domain/repositories/asset_repository.dart';
import 'package:my_app/domain/repositories/asset_task_repository.dart';
import 'package:my_app/domain/repositories/auth_repository.dart';
import 'package:my_app/domain/repositories/borrow_repository.dart';
import 'package:my_app/domain/repositories/calendar_repository.dart';
import 'package:my_app/domain/repositories/history_repository.dart';
import 'package:my_app/domain/repositories/home_repository.dart';
import 'package:my_app/domain/repositories/location_repository.dart';
import 'package:my_app/domain/repositories/notification_repository.dart';
import 'package:my_app/domain/repositories/recovery_repository.dart';
import 'package:my_app/domain/repositories/search_repository.dart';
import 'package:my_app/domain/repositories/submission_list_repository.dart';
import 'package:my_app/domain/repositories/submission_repository.dart';
import 'package:my_app/domain/repositories/user_repository.dart';
import 'package:my_app/domain/repositories/workflow_list_repository.dart';
import 'package:my_app/domain/usecases/actor_use_case.dart';
import 'package:my_app/domain/usecases/approval_step_use_case.dart';
import 'package:my_app/domain/usecases/approver_use_case.dart';
import 'package:my_app/domain/usecases/asset_task_use_case.dart';
import 'package:my_app/domain/usecases/asset_use_case.dart';
import 'package:my_app/domain/usecases/borrow_use_case.dart';
import 'package:my_app/domain/usecases/calendar_usecase.dart';
import 'package:my_app/domain/usecases/create_submission_use_case.dart';
import 'package:my_app/domain/usecases/create_user_use_case.dart';
import 'package:my_app/domain/usecases/department_list_use_case.dart';
import 'package:my_app/domain/usecases/history_use_case.dart';
import 'package:my_app/domain/usecases/home_usecase.dart';
import 'package:my_app/domain/usecases/location_use_case.dart';
import 'package:my_app/domain/usecases/login_usecase.dart';
import 'package:my_app/domain/usecases/notification_use_case.dart';
import 'package:my_app/domain/usecases/recovery_use_case.dart';
import 'package:my_app/domain/usecases/search_use_case.dart';
import 'package:my_app/domain/usecases/submission_detail_use_case.dart';
import 'package:my_app/domain/usecases/submission_list_use_case.dart';
import 'package:my_app/domain/usecases/workflow_list_use_case.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/calendar/calendar_bloc.dart';
import 'package:my_app/ui/deparment/department_list_bloc.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_bloc.dart';
import 'package:my_app/ui/deparment/form_department/form_department_bloc.dart';
import 'package:my_app/ui/home/home_bloc.dart';
import 'package:my_app/ui/in_out/approver_decison/approver_bloc.dart';
import 'package:my_app/ui/in_out/asset_submission/asset_detail/asset_task_bloc.dart';
import 'package:my_app/ui/in_out/borrow/borrow_bloc.dart';
import 'package:my_app/ui/in_out/history/borrow_history_bloc.dart';
import 'package:my_app/ui/in_out/history/handover_history_bloc.dart';
import 'package:my_app/ui/in_out/recovery/recovery_bloc.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_bloc.dart';
import 'package:my_app/ui/location_asset/form_resource_bloc.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_bloc.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_bloc.dart';
import 'package:my_app/ui/notification/notification_bloc.dart';
import 'package:my_app/ui/search/search_bloc.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_bloc.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_bloc.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_bloc.dart';
import 'package:my_app/ui/user/actor_list/actor_list_bloc.dart';
import 'package:my_app/ui/user/form_user/form_user_bloc.dart';
import 'package:my_app/ui/user/user_detail_bloc.dart';
import 'package:my_app/ui/workflow/create_workflow/create_workflow_bloc.dart';
import 'package:my_app/ui/workflow/workflow_detail/workflow_detail_bloc.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_bloc.dart';

import 'domain/repositories/department_repository.dart';
import 'domain/repositories/submission_detail_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.allowReassignment = true;

  // --- Core ---
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // --- API ---
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioClient>().dio));

  // --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<SubmissionListRepository>(
    () => SubmissionListRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<ActorRepository>(
    () => ActorRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<DepartmentRepository>(
    () => DepartmentRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<WorkflowListRepository>(
    () => WorkflowRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<ApprovalStepRepository>(
    () => ApprovalStepRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(api: sl<AuthApi>()),
  );
  sl.registerLazySingleton<SubmissionDetailRepository>(
    () => SubmissionDetailImpl(api: sl<AuthApi>()),
  );
  sl.registerLazySingleton<SubmissionRepository>(
    () => SubmissionRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<ApproverRepository>(
    () => ApproverRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<AssetTaskRepository>(
    () => AssetTaskRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<BorrowRepository>(
    () => BorrowRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<RecoveryRepository>(
    () => RecoveryRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(sl<AuthApi>()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl<AuthApi>()),
  );

  // --- UseCases ---
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => HomeUseCase(sl()));
  sl.registerLazySingleton(() => CalendarUseCase(repository: sl()));
  sl.registerLazySingleton(() => SubmissionListUseCase(repository: sl()));
  sl.registerLazySingleton(() => ActorUseCase(sl(), sl()));
  sl.registerLazySingleton(() => DepartmentListUseCase(repository: sl()));
  sl.registerLazySingleton(() => AssetUseCase(repository: sl()));
  sl.registerLazySingleton(() => LocationUseCase(repository: sl()));
  sl.registerLazySingleton(() => WorkflowListUseCase(repository: sl()));
  sl.registerLazySingleton(() => ApprovalStepUseCase(repository: sl()));
  sl.registerLazySingleton(() => NotificationUseCase(sl()));
  sl.registerLazySingleton(() => SubmissionDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateSubmissionUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => ApproverUseCase(repository: sl()));
  sl.registerLazySingleton(() => AssetTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => BorrowUseCase(repository: sl()));
  sl.registerLazySingleton(() => RecoveryUseCase(repository: sl()));
  sl.registerLazySingleton(() => HistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchUseCase(repository: sl()));

  // --- Blocs ---
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => HomeBloc(homeUseCase: sl()));
  sl.registerFactory(() => CalendarBloc(calendarUseCase: sl()));
  sl.registerFactory(() => SubmissionListBloc(submissionListUseCase: sl()));
  sl.registerFactory(
    () => ActorListBloc(actorUseCase: sl(), departmentUseCase: sl()),
  );
  sl.registerFactory(
    () => AssetLocationListBloc(assetUseCase: sl(), locationUseCase: sl()),
  );
  sl.registerFactory(() => WorkflowListBloc(workflowListUseCase: sl()));
  sl.registerFactory(
    () => CreateWorkflowBloc(
      workflowUseCase: sl(),
      approvalStepUseCase: sl(),
      departmentUseCase: sl(),
    ),
  );
  sl.registerFactory(() => WorkflowDetailBloc(useCase: sl()));
  sl.registerFactory(() => AssetDetailBloc(useCase: sl()));
  sl.registerFactory(() => LocationDetailBloc(useCase: sl()));
  sl.registerFactory(() => NotificationBloc(useCase: sl()));
  sl.registerFactory(() => SubmissionDetailBloc(useCase: sl()));
  sl.registerFactory(() => SubmissionBloc(sl(), sl()));
  sl.registerFactory(() => CreateUserBloc(sl(), sl()));
  sl.registerFactory(() => DepartmentListBloc(departmentListUseCase: sl()));
  sl.registerFactory(() => DepartmentDetailBloc(useCase: sl()));
  sl.registerFactory(() => FormDepartmentBloc(departmentListUseCase: sl()));
  sl.registerFactory(() => UserDetailBloc(sl()));
  sl.registerFactory(
    () => FormResourceBloc(
      departmentListUseCase: sl(),
      locationUseCase: sl(),
      assetUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ApproverBloc(useCase: sl()));
  sl.registerFactory(() => AssetTaskBloc(useCase: sl()));
  sl.registerFactory(() => BorrowBloc(useCase: sl()));
  sl.registerFactory(() => RecoveryBloc(useCase: sl()));
  sl.registerFactory(() => BorrowHistoryBloc(useCase: sl()));
  sl.registerFactory(() => HandoverHistoryBloc(useCase: sl()));
  sl.registerFactory(() => SearchBloc(useCase: sl()));
}
