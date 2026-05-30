import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:my_app/data/model/actor_model.dart';
import 'package:my_app/data/model/approval_step_model.dart';
import 'package:my_app/data/model/approver_submission_model.dart';
import 'package:my_app/data/model/asset_detail_model.dart';
import 'package:my_app/data/model/asset_model.dart';
import 'package:my_app/data/model/asset_task_model.dart';
import 'package:my_app/data/model/borrow_model.dart';
import 'package:my_app/data/model/calendar_model.dart';
import 'package:my_app/data/model/create_response.dart';
import 'package:my_app/data/model/create_user_response.dart';
import 'package:my_app/data/model/department_model.dart';
import 'package:my_app/data/model/history_model.dart';
import 'package:my_app/data/model/location_detail_model.dart';
import 'package:my_app/data/model/location_model.dart';
import 'package:my_app/data/model/notification_model.dart';
import 'package:my_app/data/model/recovery_model.dart';
import 'package:my_app/data/model/role_model.dart';
import 'package:my_app/data/model/search_model.dart';
import 'package:my_app/data/model/submission_model.dart';
import 'package:my_app/data/model/submission_response_model.dart';
import 'package:my_app/data/model/submission_stats_model.dart';
import 'package:my_app/data/model/submission_step_model.dart';
import 'package:my_app/data/model/user_model.dart';
import 'package:my_app/data/model/workflow_list_model.dart';
import 'package:retrofit/retrofit.dart';


part 'api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @GET("/authentication/token/new")
  Future<dynamic> getRequestToken();

  @POST("/login")
  Future<dynamic> validateWithLogin(@Body() Map<String, dynamic> body);

  @POST("/authentication/session/new")
  Future<dynamic> createSession(@Body() Map<String, dynamic> body);

  @GET("/account")
  Future<UserModel> getAccount(@Query("session_id") String sessionId);

  @POST("/notifications/save-fcm-token")
  Future<dynamic> saveFcmToken(
      @Header("Authorization") String bearerToken,
      @Body() Map<String, dynamic> body,
  );

  @GET("/v1/user/statistics")
  Future<SubmissionStatsModel> getStatistics(@Query("user_id") int userId);

  @GET("/v1/submissions/recent")
  Future<List<SubmissionModel>> getRecentSubmissions(@Query("user_id") int userId);

  @GET("/submissions/calendar")
  Future<CalendarResponseModel> getCalendarSubmissions(
      @Query("month") int month,
      @Query("year") int year,
      );

  @GET("/v1/submissions")
  Future<SubmissionResponseModel> getMySubmissions(
      @Query("user_id") int userId,
      @Query("type") String type,
      );

  @GET("/actor/list")
  Future<ActorResponseModel> getActorList();

  @GET("/actor/detail/{id}")
  Future<UserResponse> getActorDetail(
      @Path("id") int id,
      );


  @GET("/department/list")
  Future<DepartmentResponseModel> getDepartmentList();

  @GET("/asset/list")
  Future<AssetResponseModel> getAssetList();

  @GET("/location/list")
  Future<LocationResponseModel> getLocationList();
  
  @GET("/workflow/list")
  Future<WorkflowListResponseModel> getWorkflowList();

  @GET("/workflow/detail/{id}")
  Future<WorkflowDetail> getWorkflowDetail(@Path("id") int id);

  @GET("/asset/detail/{id}")
  Future<AssetDetailModel> getAssetDetail(@Path("id") int id);

  @GET("/location/detail/{id}")
  Future<LocationDetailModel> getLocationDetail(@Path("id") int id);

  @GET("/notifications/list")
  Future<NotificationResponseModel> getNotificationList(
      @Query("user_id") int userId,
  );

  @POST("/notifications/{id}/read")
  Future<dynamic> markAsRead(@Body() Map<String, dynamic> body);

  @POST("/notifications/read_all/{user_id}")
  Future<dynamic> markAllAsRead(@Path("user_id") int userId);
  
  @GET("/v1/submissions/{id}/detail")
  Future<SubmissionStepModel> getSubmissionDetail(@Path("id") int id);

  @GET("/v1/departments/resources")
  Future<DepartmentResponseModel> getDepartmentResources();

  @POST("/v1/submissions")
  Future<CreateResponse> createSubmission(
      @Part(name: "title") String title,
      @Part(name: "workflow_id") int workflowId,
      @Part(name: "start_date") String startDate,
      @Part(name: "end_date") String endDate,
      @Part(name: "creator_id") int creatorId,
      @Part(name: "departments") String departmentsJson,
      @Part(name: "description") String? description,
      @Part(name: "attachments[]") List<dio.MultipartFile>? attachments,
      );
  @POST("/actor/create")
  Future<CreateResponse> createUser(@Body() Map<String, dynamic> body);

  @GET("/role/list")
  Future<RoleResponseModel> getRoleList();

  @GET("/department/{id}/detail")
  Future<DepartmentDetailResponseModel> getDepartmentDetail(@Path("id") int id);

  @POST("/department/create")
  Future<CreateResponse> createDepartment(
      @Part(name: "dept_name") String deptName,
      @Part(name: "location_desc") String locationDesc,
      @Part(name: "parent_dept_id") int? parentDeptId,
      );

  @POST("/asset/create")
  Future<CreateResponse> createAsset(@Body() Map<String, dynamic> body);

  @POST("/location/create")
  Future<CreateResponse> createLocation(@Body() Map<String, dynamic> body);

  // data/api/api.dart — thêm vào AuthApi
  @GET("/v1/approver/submission/{submissionId}")
  Future<ApproverSubmissionResponse> getApproverSubmission(
      @Path("submissionId") int submissionId,
      @Query("dept_id") int deptId,
      );

  @POST("/v1/approver/submission/{submissionId}/decide")
  Future<CreateResponse> decideSubmission(
      @Path("submissionId") int submissionId,
      @Body() Map<String, dynamic> body,
      );

  @GET("/asset/asset-tasks")
  Future<AssetTaskListResponse> getAssetTasks(
      @Query("dept_id") int deptId, {
        @Query("search") String? search,
        @Query("status") String? status,
      });

  @GET("/asset/asset-tasks/{submissionId}")
  Future<AssetTaskDetailResponse> getAssetTaskDetail(
      @Path("submissionId") int submissionId,
      @Query("dept_id") int deptId,
      );

  @POST("/asset/asset-tasks/{submissionId}/handover")
  Future<HandoverResponse> handoverAssets(
      @Path("submissionId") int submissionId,
      @Body() Map<String, dynamic> body,
      );

  @GET("/v1/borrow/list")
  Future<BorrowListResponse> getBorrowList(
      @Query("user_id") int userId, {
        @Query("search") String? search,
      });

  @POST("/v1/borrow/{submissionId}/confirm-receive")
  Future<BorrowActionResponse> confirmReceive(
      @Path("submissionId") int submissionId,
      @Body() Map<String, dynamic> body,
      );

  @POST("/v1/borrow/{submissionId}/return")
  Future<BorrowActionResponse> returnAssets(
      @Path("submissionId") int submissionId,
      @Body() Map<String, dynamic> body,
      );
  @GET("/v1/manager/recovery/list")
  Future<RecoveryListResponse> getRecoveryList(
      @Query("handler_id") int handlerId, {
        @Query("search") String? search,
      });

  @POST("/v1/manager/{submissionId}/confirm-recovery")
  Future<RecoveryActionResponseModel> confirmRecovery(
      @Path("submissionId") int submissionId,
      @Body() Map<String, dynamic> body,
      );

  @POST("/v1/manager/{submissionId}/remind-return")
  Future<RecoveryActionResponseModel> remindReturn(
      @Path("submissionId") int submissionId,
      @Body() Map<String, dynamic> body,
      );

  @GET("/v1/history/borrow")
  Future<BorrowHistoryListResponse> getBorrowHistory(
      @Query("user_id") int userId, {
        @Query("search") String? search,
      });

  @GET("/v1/history/handover")
  Future<HandoverHistoryListResponse> getHandoverHistory(
      @Query("user_id") int userId, {
        @Query("search") String? search,
      });

  @GET("/v1/search")
  Future<SearchListResponse> search(
      @Query("user_id") int userId,
      @Query("q") String query, {
        @Query("filter") String filter = 'all',
      });
}