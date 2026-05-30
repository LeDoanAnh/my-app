import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống phê duyệt tờ trình'**
  String get appTitle;

  /// No description provided for @appShortTitle.
  ///
  /// In vi, this message translates to:
  /// **'E-Submission'**
  String get appShortTitle;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @username.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get username;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @welcomeBack.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get welcomeBack;

  /// No description provided for @systemSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống quản lý tờ trình nội bộ'**
  String get systemSubtitle;

  /// No description provided for @enterUsername.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên đăng nhập'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordContent.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng liên hệ Quản trị viên (IT Support) để cấp lại mật khẩu mới.'**
  String get forgotPasswordContent;

  /// No description provided for @understood.
  ///
  /// In vi, this message translates to:
  /// **'Đã hiểu'**
  String get understood;

  /// No description provided for @errorNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo lỗi'**
  String get errorNotice;

  /// No description provided for @notification.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notification;

  /// No description provided for @notifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đọc tất cả'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa có thông báo nào'**
  String get noNotifications;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm tờ trình, thiết bị...'**
  String get searchHint;

  /// No description provided for @searchPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Nhập từ khóa để tìm kiếm'**
  String get searchPrompt;

  /// No description provided for @recentSearches.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm gần đây'**
  String get recentSearches;

  /// No description provided for @clearAll.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tất cả'**
  String get clearAll;

  /// No description provided for @noSearchResults.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy kết quả phù hợp'**
  String get noSearchResults;

  /// No description provided for @all.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get all;

  /// No description provided for @submission.
  ///
  /// In vi, this message translates to:
  /// **'Tờ trình'**
  String get submission;

  /// No description provided for @asset.
  ///
  /// In vi, this message translates to:
  /// **'Thiết bị'**
  String get asset;

  /// No description provided for @user.
  ///
  /// In vi, this message translates to:
  /// **'Nhân viên'**
  String get user;

  /// No description provided for @department.
  ///
  /// In vi, this message translates to:
  /// **'Phòng ban'**
  String get department;

  /// No description provided for @other.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get other;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @menu.
  ///
  /// In vi, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @settingsSecurity.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt/Bảo mật'**
  String get settingsSecurity;

  /// No description provided for @support.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ'**
  String get support;

  /// No description provided for @helpCenter.
  ///
  /// In vi, this message translates to:
  /// **'Trung tâm trợ giúp'**
  String get helpCenter;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @version.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get version;

  /// No description provided for @unverified.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xác minh'**
  String get unverified;

  /// No description provided for @unknownUser.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get unknownUser;

  /// No description provided for @logoutConfirmContent.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn muốn thoát tài khoản không?'**
  String get logoutConfirmContent;

  /// No description provided for @success.
  ///
  /// In vi, this message translates to:
  /// **'Thành công'**
  String get success;

  /// No description provided for @failure.
  ///
  /// In vi, this message translates to:
  /// **'Thất bại'**
  String get failure;

  /// No description provided for @ok.
  ///
  /// In vi, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @retryAction.
  ///
  /// In vi, this message translates to:
  /// **'Thực hiện lại'**
  String get retryAction;

  /// No description provided for @submissionList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách tờ đơn'**
  String get submissionList;

  /// No description provided for @createSubmission.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tờ trình'**
  String get createSubmission;

  /// No description provided for @pending.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get rejected;

  /// No description provided for @waitingApproval.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get waitingApproval;

  /// No description provided for @totalSubmissions.
  ///
  /// In vi, this message translates to:
  /// **'Tổng đơn'**
  String get totalSubmissions;

  /// No description provided for @manageSubmissions.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý tờ trình'**
  String get manageSubmissions;

  /// No description provided for @manageAssets.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý vật tư'**
  String get manageAssets;

  /// No description provided for @recentActivities.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động gần đây'**
  String get recentActivities;

  /// No description provided for @createRequest.
  ///
  /// In vi, this message translates to:
  /// **'Tạo đơn'**
  String get createRequest;

  /// No description provided for @requestInbox.
  ///
  /// In vi, this message translates to:
  /// **'Đơn từ'**
  String get requestInbox;

  /// No description provided for @handover.
  ///
  /// In vi, this message translates to:
  /// **'Bàn giao'**
  String get handover;

  /// No description provided for @recovery.
  ///
  /// In vi, this message translates to:
  /// **'Thu hồi'**
  String get recovery;

  /// No description provided for @noRecentActivities.
  ///
  /// In vi, this message translates to:
  /// **'Không có hoạt động gần đây'**
  String get noRecentActivities;

  /// No description provided for @untitled.
  ///
  /// In vi, this message translates to:
  /// **'Không có tiêu đề'**
  String get untitled;

  /// No description provided for @noStatus.
  ///
  /// In vi, this message translates to:
  /// **'Không có trạng thái'**
  String get noStatus;

  /// No description provided for @noTime.
  ///
  /// In vi, this message translates to:
  /// **'Không có thời gian'**
  String get noTime;

  /// No description provided for @searchSubmissionHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm mã đơn hoặc tiêu đề...'**
  String get searchSubmissionHint;

  /// No description provided for @needApproval.
  ///
  /// In vi, this message translates to:
  /// **'Cần duyệt'**
  String get needApproval;

  /// No description provided for @creator.
  ///
  /// In vi, this message translates to:
  /// **'Người tạo'**
  String get creator;

  /// No description provided for @approver.
  ///
  /// In vi, this message translates to:
  /// **'Người duyệt'**
  String get approver;

  /// No description provided for @waiting.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ'**
  String get waiting;

  /// No description provided for @category.
  ///
  /// In vi, this message translates to:
  /// **'Loại đơn'**
  String get category;

  /// No description provided for @noData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get noData;

  /// No description provided for @noDataForThisSection.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu cho mục này'**
  String get noDataForThisSection;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @approvalDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết phê duyệt'**
  String get approvalDetail;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPassword;

  /// No description provided for @enterPasswordToContinue.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu để tiếp tục'**
  String get enterPasswordToContinue;

  /// No description provided for @continueAction.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continueAction;

  /// No description provided for @approvalNote.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ghi chú phê duyệt (nếu có)...'**
  String get approvalNote;

  /// No description provided for @approvalNoteSection.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú phê duyệt'**
  String get approvalNoteSection;

  /// No description provided for @timeSection.
  ///
  /// In vi, this message translates to:
  /// **'Thời gian'**
  String get timeSection;

  /// No description provided for @locationSection.
  ///
  /// In vi, this message translates to:
  /// **'Địa điểm'**
  String get locationSection;

  /// No description provided for @assetSection.
  ///
  /// In vi, this message translates to:
  /// **'Vật tư'**
  String get assetSection;

  /// No description provided for @sender.
  ///
  /// In vi, this message translates to:
  /// **'Người gửi'**
  String get sender;

  /// No description provided for @start.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get start;

  /// No description provided for @end.
  ///
  /// In vi, this message translates to:
  /// **'Kết thúc'**
  String get end;

  /// No description provided for @approvedThisSubmission.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt tờ trình này.'**
  String get approvedThisSubmission;

  /// No description provided for @rejectedThisSubmission.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối tờ trình này.'**
  String get rejectedThisSubmission;

  /// No description provided for @approveApplication.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt đơn'**
  String get approveApplication;

  /// No description provided for @rejectUpper.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get rejectUpper;

  /// No description provided for @greetingUser.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào {name}'**
  String greetingUser(String name);

  /// No description provided for @activeWorkflows.
  ///
  /// In vi, this message translates to:
  /// **'{count} luồng đang hoạt động'**
  String activeWorkflows(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
