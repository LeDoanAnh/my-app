import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:my_app/core/l10n/app_localizations.dart';
import 'package:my_app/core/router/app_router.dart';
import 'package:my_app/core/settings/app_settings_controller.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/firebase_options.dart';
import 'package:my_app/injection_container.dart' as di;
import 'package:my_app/notification_service.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/auth/blog/auth_event.dart';
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
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'data/local/search_history_box.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await di.init();
  await Hive.openBox<String>('user_box');

  final talker = Talker();
  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(enabled: kDebugMode),
  );

  final messaging = FirebaseMessaging.instance;
  final token = await messaging.getToken();
  if (kDebugMode) print('FCM token: $token');

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  await messaging.subscribeToTopic('duyet_to_trinh');

  final notificationService = NotificationService();
  await notificationService.initFCM();
  await SearchHistoryBox.init();
  await appSettingsController.load();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc = di.sl<AuthBloc>()..add(AppStarted());
  late final AppRouter _appRouter = AppRouter(authBloc: _authBloc);

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<HomeBloc>(create: (_) => di.sl<HomeBloc>()),
        BlocProvider(create: (_) => di.sl<CalendarBloc>()),
        BlocProvider(create: (_) => di.sl<SubmissionListBloc>()),
        BlocProvider(create: (_) => di.sl<ActorListBloc>()),
        BlocProvider(create: (_) => di.sl<AssetLocationListBloc>()),
        BlocProvider(create: (_) => di.sl<WorkflowListBloc>()),
        BlocProvider(create: (_) => di.sl<CreateWorkflowBloc>()),
        BlocProvider(create: (_) => di.sl<WorkflowDetailBloc>()),
        BlocProvider(create: (_) => di.sl<AssetDetailBloc>()),
        BlocProvider(create: (_) => di.sl<LocationDetailBloc>()),
        BlocProvider(create: (_) => di.sl<NotificationBloc>()),
        BlocProvider(create: (_) => di.sl<SubmissionDetailBloc>()),
        BlocProvider(create: (_) => di.sl<SubmissionBloc>()),
        BlocProvider(create: (_) => di.sl<CreateUserBloc>()),
        BlocProvider(create: (_) => di.sl<DepartmentListBloc>()),
        BlocProvider(create: (_) => di.sl<DepartmentDetailBloc>()),
        BlocProvider(create: (_) => di.sl<FormDepartmentBloc>()),
        BlocProvider(create: (_) => di.sl<UserDetailBloc>()),
        BlocProvider(create: (_) => di.sl<FormResourceBloc>()),
        BlocProvider(create: (_) => di.sl<ApproverBloc>()),
        BlocProvider(create: (_) => di.sl<AssetTaskBloc>()),
        BlocProvider(create: (_) => di.sl<BorrowBloc>()),
        BlocProvider(create: (_) => di.sl<RecoveryBloc>()),
        BlocProvider(create: (_) => di.sl<BorrowHistoryBloc>()),
        BlocProvider(create: (_) => di.sl<HandoverHistoryBloc>()),
        BlocProvider(create: (_) => di.sl<SearchBloc>()),
      ],
      child: AnimatedBuilder(
        animation: appSettingsController,
        builder: (context, _) => MaterialApp.router(
          routerConfig: _appRouter.router,
          title: AppLocalizations(appSettingsController.locale).t('appTitle'),
          debugShowCheckedModeBanner: false,
          theme: AppColors.theme(),
          darkTheme: AppColors.darkTheme(),
          themeMode: appSettingsController.themeMode,
          locale: appSettingsController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (kDebugMode) print('Background message: ${message.notification?.title}');
}
