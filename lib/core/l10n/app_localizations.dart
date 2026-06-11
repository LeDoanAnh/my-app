import 'package:flutter/material.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('vi'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('vi'));
  }

  static const _values = {
    'vi': {
      'appTitle': 'Hệ thống phê duyệt',
      'profile': 'Hồ sơ',
      'account': 'Tài khoản',
      'personalInfo': 'Thông tin cá nhân',
      'personalInfoSubtitle': 'Cập nhật hồ sơ của bạn',
      'security': 'Bảo mật',
      'securitySubtitle': 'Mật khẩu & xác thực 2 lớp',
      'application': 'Ứng dụng',
      'theme': 'Giao diện',
      'themeSubtitle': 'Sáng / Tối / Theo hệ thống',
      'language': 'Ngôn ngữ',
      'support': 'Hỗ trợ',
      'helpCenter': 'Trung tâm trợ giúp',
      'helpCenterSubtitle': 'FAQ & hướng dẫn sử dụng',
      'contactSupport': 'Liên hệ hỗ trợ',
      'contactSupportSubtitle': 'Chat trực tiếp với đội ngũ',
      'logout': 'Đăng xuất',
      'logoutConfirmTitle': 'Đăng xuất',
      'logoutConfirmContent': 'Bạn có chắc muốn thoát tài khoản không?',
      'version': 'Phiên bản 2.2.3',
      'chooseTheme': 'Chọn giao diện',
      'chooseLanguage': 'Chọn ngôn ngữ',
      'light': 'Sáng',
      'dark': 'Tối',
      'system': 'Theo hệ thống',
      'vietnamese': 'Tiếng Việt',
      'english': 'English',
      'user': 'Người dùng',
      'verified': 'Đã xác minh',
      'unverified': 'Chưa xác minh',
      'notice': 'Thông báo',
      'sessionExpired': 'Phiên đăng nhập hết hạn',
    },
    'en': {
      'appTitle': 'Approval System',
      'profile': 'Profile',
      'account': 'Account',
      'personalInfo': 'Personal information',
      'personalInfoSubtitle': 'Update your profile',
      'security': 'Security',
      'securitySubtitle': 'Password & two-factor authentication',
      'application': 'Application',
      'theme': 'Appearance',
      'themeSubtitle': 'Light / Dark / System',
      'language': 'Language',
      'support': 'Support',
      'helpCenter': 'Help center',
      'helpCenterSubtitle': 'FAQ & user guides',
      'contactSupport': 'Contact support',
      'contactSupportSubtitle': 'Chat directly with the team',
      'logout': 'Log out',
      'logoutConfirmTitle': 'Log out',
      'logoutConfirmContent': 'Are you sure you want to sign out?',
      'version': 'Version 2.2.3',
      'chooseTheme': 'Choose appearance',
      'chooseLanguage': 'Choose language',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'vietnamese': 'Tiếng Việt',
      'english': 'English',
      'user': 'User',
      'verified': 'Verified',
      'unverified': 'Unverified',
      'notice': 'Notice',
      'sessionExpired': 'Session expired',
    },
  };

  String t(String key) {
    return _values[locale.languageCode]?[key] ?? _values['vi']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((supported) => supported.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
