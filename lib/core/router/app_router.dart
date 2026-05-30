import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/auth/blog/auth_state.dart';
import 'package:my_app/ui/auth/blog/login_screen.dart';
import 'package:my_app/ui/auth/profile_screen.dart';
import 'package:my_app/ui/calendar/calendar_screen.dart';
import 'package:my_app/ui/deparment/deparment_list_screen.dart';
import 'package:my_app/ui/deparment/detail_deparment/department_detail_screen.dart';
import 'package:my_app/ui/deparment/form_department/create_derpartment_screen.dart';
import 'package:my_app/ui/in_out/approver_decison/approver_decision_screen.dart';
import 'package:my_app/ui/in_out/asset_submission/asset_detail/asset_submission_detail_screen.dart';
import 'package:my_app/ui/in_out/asset_submission/asset_detail/asset_submission_list_screen.dart';
import 'package:my_app/ui/in_out/borrow/staff_borrowed_list_screen.dart';
import 'package:my_app/ui/in_out/history/manager_history_list_screen.dart';
import 'package:my_app/ui/in_out/recovery/manager_recovery_list_screen.dart';
import 'package:my_app/ui/location_asset/asset_detail/asset_detail_screen.dart';
import 'package:my_app/ui/location_asset/create_resource_screen.dart';
import 'package:my_app/ui/location_asset/location_asset_list/asset_location_list_screen.dart';
import 'package:my_app/ui/location_asset/location_detail/location_detail_screen.dart';
import 'package:my_app/ui/main_screen.dart';
import 'package:my_app/ui/notification/notification_screen.dart';
import 'package:my_app/ui/search/search_screen.dart';
import 'package:my_app/ui/submission/create_submission/create_submission_screen.dart';
import 'package:my_app/ui/submission/submission_detail/submission_detail_screen.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_screen.dart';
import 'package:my_app/ui/user/actor_list/user_list_screen.dart';
import 'package:my_app/ui/user/form_user/create_user_screen.dart';
import 'package:my_app/ui/user/user_detail_screen.dart';
import 'package:my_app/ui/workflow/create_workflow_screen.dart';
import 'package:my_app/ui/workflow/workflow_detail/workflow_detail_screen.dart';
import 'package:my_app/ui/workflow/workflow_list/workflow_list_screen.dart';

/// Lắng nghe BLoC stream để GoRouter tự redirect khi auth thay đổi
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,

    // ── AUTH REDIRECT ────────────────────────────────────────────
    redirect: (context, state) {
      final authState = authBloc.state;
      final location = state.matchedLocation;
      final isLoginRoute = location == '/login';

      if (authState is AuthLoading) return null;
      if (authState is Unauthenticated && !isLoginRoute) return '/login';
      if (authState is Authenticated && isLoginRoute) return '/main';
      return null;
    },

    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    // ── ROUTES ───────────────────────────────────────────────────
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) {
          // Lấy user từ authBloc thay vì extra
          final authState = authBloc.state;
          if (authState is Authenticated) {
            return MainScreen(user: authState.user);
          }
          return const LoginScreen(); // fallback
        },
      ),

      // ── SUBMISSION ─────────────────────────────────────────────
      GoRoute(
        path: '/submission-list',
        name: 'submission-list',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return SubmissionListScreen(user: user);
        },
      ),
      GoRoute(
        path: '/submission-detail/:id',
        name: 'submission-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SubmissionDetailScreen(submissionId: id);
        },
      ),
      GoRoute(
        path: '/create-submission',
        name: 'create-submission',
        builder: (context, state) {
          final userId = state.extra as int?;
          return CreateSubmissionScreen(userId: userId);
        },
      ),

      // ── NOTIFICATION & SEARCH ──────────────────────────────────
      GoRoute(
        path: '/notification/:userId',
        name: 'notification',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          return NotificationScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/search/:userId',
        name: 'search',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          return SearchScreen(userId: userId);
        },
      ),

      // ── APPROVER ───────────────────────────────────────────────
      GoRoute(
        path: '/approver-decision',
        name: 'approver-decision',
        builder: (context, state) {
          final args = state.extra as Map<String, int>;
          return ApproverDecisionScreen(
            submissionId: args['submissionId']!,
            deptId: args['deptId']!,
            approverId: args['approverId']!,
          );
        },
      ),

      // ── DEPARTMENT ─────────────────────────────────────────────
      GoRoute(
        path: '/department-list',
        name: 'department-list',
        builder: (context, state) => DepartmentListScreen(),
      ),
      GoRoute(
        path: '/department-detail/:id',
        name: 'department-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DepartmentDetailScreen(departmentId: id);
        },
      ),
      GoRoute(
        path: '/create-department',
        name: 'create-department',
        builder: (context, state) => CreateDepartmentScreen(),
      ),

      // ── ASSET & LOCATION ───────────────────────────────────────
      GoRoute(
        path: '/asset-location-list',
        name: 'asset-location-list',
        builder: (context, state) => const AssetLocationListScreen(),
      ),
      GoRoute(
        path: '/asset-detail/:id',
        name: 'asset-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AssetDetailScreen(assetId: id);
        },
      ),
      GoRoute(
        path: '/location-detail/:id',
        name: 'location-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LocationDetailScreen(locationId: id);
        },
      ),
      GoRoute(
        path: '/create-resource',
        name: 'create-resource',
        builder: (context, state) => const CreateResourceScreen(),
      ),

      // ── ASSET SUBMISSION ───────────────────────────────────────
      GoRoute(
        path: '/asset-submission-list',
        name: 'asset-submission-list',
        builder: (context, state) {
          final args = state.extra as Map<String, int>;
          return AssetSubmissionListScreen(
            deptId: args['deptId']!,
            handlerId: args['handlerId']!,
          );
        },
      ),
      GoRoute(
        path: '/asset-submission-detail',
        name: 'asset-submission-detail',
        builder: (context, state) {
          final args = state.extra as Map<String, int>;
          return AssetSubmissionDetailScreen(
            submissionId: args['submissionId']!,
            deptId: args['deptId']!,
            handlerId: args['handlerId']!,
          );
        },
      ),

      // ── BORROW / RECOVERY / HISTORY ────────────────────────────
      GoRoute(
        path: '/staff-borrowed-list/:userId',
        name: 'staff-borrowed-list',
        builder: (context, state) {
          final userId = int.parse(state.pathParameters['userId']!);
          return StaffBorrowedListScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/manager-recovery-list/:handlerId',
        name: 'manager-recovery-list',
        builder: (context, state) {
          final handlerId = int.parse(state.pathParameters['handlerId']!);
          return ManagerRecoveryListScreen(handlerId: handlerId);
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return HistoryScreen(
            userId: args['userId'] as int,
            userRoles: args['userRoles'] as List<int?>,
          );
        },
      ),

      // ── WORKFLOW ───────────────────────────────────────────────
      GoRoute(
        path: '/workflow-list',
        name: 'workflow-list',
        builder: (context, state) => const WorkflowListScreen(),
      ),
      GoRoute(
        path: '/workflow-detail/:id',
        name: 'workflow-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return WorkflowDetailScreen(workflowId: id);
        },
      ),
      GoRoute(
        path: '/create-workflow',
        name: 'create-workflow',
        builder: (context, state) => const CreateWorkflowScreen(),
      ),

      // ── USER ───────────────────────────────────────────────────
      GoRoute(
        path: '/user-list',
        name: 'user-list',
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: '/user-detail/:id',
        name: 'user-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return UserDetailScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/create-user',
        name: 'create-user',
        builder: (context, state) => const CreateUserScreen(),
      ),

      // ── MISC ───────────────────────────────────────────────────
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],

    // ── 404 ──────────────────────────────────────────────────────
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Trang không tồn tại'))),
  );
}
