// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'E-Submission Approval System';

  @override
  String get appShortTitle => 'E-Submission';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get systemSubtitle => 'Internal submission management system';

  @override
  String get enterUsername => 'Enter username';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get forgotPasswordContent =>
      'Please contact the administrator (IT Support) to reset your password.';

  @override
  String get understood => 'Got it';

  @override
  String get errorNotice => 'Error notice';

  @override
  String get notification => 'Notification';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'You have no notifications';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search submissions, equipment...';

  @override
  String get searchPrompt => 'Enter a keyword to search';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get clearAll => 'Clear all';

  @override
  String get noSearchResults => 'No matching results found';

  @override
  String get all => 'All';

  @override
  String get submission => 'Submission';

  @override
  String get asset => 'Asset';

  @override
  String get user => 'Employee';

  @override
  String get department => 'Department';

  @override
  String get other => 'Other';

  @override
  String get profile => 'Profile';

  @override
  String get menu => 'Menu';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSecurity => 'Settings/Security';

  @override
  String get support => 'Support';

  @override
  String get helpCenter => 'Help center';

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get version => 'Version 2.2.3';

  @override
  String get unverified => 'Unverified';

  @override
  String get unknownUser => 'User';

  @override
  String get logoutConfirmContent => 'Are you sure you want to sign out?';

  @override
  String get success => 'Success';

  @override
  String get failure => 'Failure';

  @override
  String get ok => 'OK';

  @override
  String get retryAction => 'Try again';

  @override
  String get submissionList => 'Submission list';

  @override
  String get createSubmission => 'Create new submission';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get waitingApproval => 'Waiting approval';

  @override
  String get totalSubmissions => 'Total';

  @override
  String get manageSubmissions => 'Submission management';

  @override
  String get manageAssets => 'Asset management';

  @override
  String get recentActivities => 'Recent activities';

  @override
  String get createRequest => 'Create request';

  @override
  String get requestInbox => 'Requests';

  @override
  String get handover => 'Handover';

  @override
  String get recovery => 'Recovery';

  @override
  String get noRecentActivities => 'No recent activities';

  @override
  String get untitled => 'Untitled';

  @override
  String get noStatus => 'No status';

  @override
  String get noTime => 'No time';

  @override
  String get searchSubmissionHint => 'Search code or title...';

  @override
  String get needApproval => 'Need approval';

  @override
  String get creator => 'Creator';

  @override
  String get approver => 'Approver';

  @override
  String get waiting => 'Waiting';

  @override
  String get category => 'Category';

  @override
  String get noData => 'No data available';

  @override
  String get noDataForThisSection => 'No data for this section';

  @override
  String get retry => 'Retry';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get approvalDetail => 'Approval detail';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get enterPasswordToContinue => 'Enter password to continue';

  @override
  String get continueAction => 'Continue';

  @override
  String get approvalNote => 'Add approval note (optional)...';

  @override
  String get approvalNoteSection => 'APPROVAL NOTE';

  @override
  String get timeSection => 'TIME';

  @override
  String get locationSection => 'LOCATIONS (YOUR DEPARTMENT)';

  @override
  String get assetSection => 'ASSETS (YOUR DEPARTMENT)';

  @override
  String get sender => 'Sender';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get approvedThisSubmission => 'You approved this submission';

  @override
  String get rejectedThisSubmission => 'You rejected this submission';

  @override
  String get approveApplication => 'APPROVE';

  @override
  String get rejectUpper => 'REJECT';

  @override
  String greetingUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String activeWorkflows(int count) {
    return 'Active: $count workflows';
  }
}
