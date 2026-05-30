import 'package:flutter/material.dart';

class TrText extends StatelessWidget {
  const TrText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      uiText(context, data),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel == null
          ? null
          : uiText(context, semanticsLabel!),
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

String uiText(BuildContext context, String value) {
  final languageCode = Localizations.localeOf(context).languageCode;
  if (languageCode != 'en') return value;
  return UiText.translateToEnglish(value);
}

String tr(BuildContext context, String value) => uiText(context, value);

class UiText {
  static String translateToEnglish(String value) {
    final exact = _en[value];
    if (exact != null) return exact;

    for (final rule in _prefixRules) {
      if (value.startsWith(rule.$1)) {
        return '${rule.$2}${value.substring(rule.$1.length)}';
      }
    }

    return value;
  }

  static const Map<String, String> _en = {
    'H? th?ng ph? duy?t t? tr?nh': 'E-Submission Approval System',
    '??ng nh?p': 'Login',
    '??ng xu?t': 'Logout',
    'T?i kho?n': 'Username',
    'M?t kh?u': 'Password',
    'Ch?o m?ng tr? l?i': 'Welcome back',
    'H? th?ng qu?n l? t? tr?nh n?i b?': 'Internal submission management system',
    'Nh?p t?n ??ng nh?p': 'Enter username',
    'Nh?p m?t kh?u': 'Enter password',
    'Qu?n m?t kh?u?': 'Forgot password?',
    'Th?ng b?o': 'Notification',
    'Th?ng b?o l?i': 'Error notice',
    '?? hi?u': 'Got it',
    'Th? l?i': 'Retry',
    'Th?c hi?n l?i': 'Try again',
    'OK': 'OK',
    'H?y': 'Cancel',
    'X?c nh?n': 'Confirm',
    'Ti?p t?c': 'Continue',
    'T?o': 'Create',
    'T?o ti?p': 'Create another',
    'T?o th?nh c?ng!': 'Created successfully!',
    'Ho?n t?t & Tho?t': 'Done & Exit',
    'Ki?m tra l?i': 'Check again',
    'R?i kh?i': 'Leave',
    'Ti?p t?c nh?p': 'Keep editing',
    'Quay v?': 'Back',
    'T?o th?m': 'Create more',
    'V? trang ch?': 'Go home',
    'T?m ki?m': 'Search',
    'T?m ki?m...': 'Search...',
    'T?m ki?m t? tr?nh...': 'Search submissions...',
    'T?m m? ??n ho?c t?n v?t t?...': 'Search request code or asset name...',
    'T?m ki?m m? ho?c t?n ??n v?...': 'Search department code or name...',
    'T?m ki?m t?n ho?c m? ng??i d?ng...': 'Search name or user code...',
    'T?m t?n ng??i m??n ho?c t? tr?nh...': 'Search borrower or submission...',
    'T?m m? ho?c t?n v?t t?...': 'Search asset code or name...',
    'T?m t?n ??a ?i?m...': 'Search location name...',
    'T?m ki?m ph?ng ban...': 'Search departments...',
    'Ch?n ph?ng ban...': 'Choose department...',
    'Ph?ng ban / ??n v?': 'Department / Unit',
    'Tr?c thu?c ??n v?': 'Parent department',
    'Tr?c thu?c ??n v? (Parent Department)': 'Parent department',
    'Kh?ng c? (??n v? g?c)': 'None (Root unit)',
    'Kh?ng r?': 'Unknown',
    'Kh?ng t?n': 'Unnamed',
    'Kh?ng c? ti?u ??': 'Untitled',
    'Kh?ng c? n?i dung': 'No content',
    'Kh?ng c? ph?n h?i': 'No response',
    'Kh?ng c? d? li?u': 'No data available',
    'Kh?ng c? l?ch tr?nh n?o': 'No schedules',
    'Kh?ng c? l?ch s? ho?t ??ng': 'No activity history',
    'Kh?ng c? quy tr?nh n?o': 'No workflows yet',
    'Ch?a c? quy tr?nh n?o': 'No workflows yet',
    'Ch?a c? c?u h?nh b??c duy?t': 'No approval step configuration',
    'Kh?ng c? ?? ?ang m??n': 'No borrowed items',
    'Kh?ng c? ?? c?n thu h?i': 'No items to recover',
    'Kh?ng c? v?t t? n?o c?n tr?': 'No assets to return',
    'Kh?ng c? v?t t? n?o c?n b?n giao': 'No assets to hand over',
    'Kh?ng t?m th?y ??n v? ph? h?p': 'No matching departments found',
    'Kh?ng t?m th?y ??n v?t t? n?o': 'No asset submissions found',
    'Vui l?ng ch?n ??n v? ph? tr?ch':
        'Please choose the responsible department',
    'Vui l?ng ch?n ?t nh?t m?t vai tr?': 'Please select at least one role',
    'Vui l?ng ch?n ph?ng ban': 'Please select a department',
    'Vui l?ng nh?p t?n': 'Please enter a name',
    'Vui l?ng nh?p m?': 'Please enter a code',
    'Vui l?ng nh?p ??n v?': 'Please enter a unit',
    'Vui l?ng nh?p ??a ch?': 'Please enter an address',
    'Vui l?ng nh?p s?c ch?a': 'Please enter capacity',
    'Duy?t': 'Approve',
    'T? ch?i': 'Reject',
    'DUY?T ??N': 'APPROVE',
    'T? CH?I': 'REJECT',
    'B?N GIAO': 'HAND OVER',
    'TR? ??': 'RETURN',
    '?? duy?t': 'Approved',
    '?ang ch?': 'Pending',
    'Ch? duy?t': 'Waiting approval',
    '?? thu h?i': 'Recovered',
    'G?i nh?c': 'Send reminder',
    '?? nh?n ??': 'Received all',
    'Tr? ??': 'Return items',
    'B?n giao': 'Hand over',
    'X?c nh?n ?? thu h?i?': 'Confirm recovery?',
    'G?i nh?c nh??': 'Send reminder?',
    'X?c nh?n nh?n ?? ???': 'Confirm all items received?',
    'X?c nh?n tr? ???': 'Confirm return?',
    'X?c nh?n b?n giao': 'Confirm handover',
    'X?c nh?n t?o v?t t?': 'Confirm asset creation',
    'X?c nh?n t?o ??a ?i?m': 'Confirm location creation',
    'X?c nh?n t?o ph?ng ban': 'Confirm department creation',
    'H?y t?o ph?ng ban?': 'Cancel department creation?',
    'G?i t? tr?nh th?nh c?ng!': 'Submission sent successfully!',
    'T?o t?i kho?n th?nh c?ng!': 'Account created successfully!',
    'T?o ph?ng ban': 'Create department',
    'T?o t? tr?nh': 'Create submission',
    'T?o t? tr?nh m?i': 'Create new submission',
    'T?o m?i CSVC': 'Create facility',
    'Th?m m?i CSVC': 'Add facility',
    'Th?m lu?ng duy?t': 'Add approval workflow',
    'Th?m ng??i d?ng': 'Add user',
    'Danh s?ch lu?ng': 'Workflow list',
    'Danh s?ch ph?ng': 'Department list',
    'Danh s?ch CSVC': 'Facility list',
    'Danh s?ch User': 'User list',
    'Danh s?ch ??n v?t t?': 'Asset submission list',
    'Danh s?ch ?n b?n giao': 'Handover request list',
    'Danh s?ch ?? m??n': 'Borrowed list',
    'Danh s?ch ??n m??n': 'Borrow request list',
    'L?ch s? m??n': 'Borrow history',
    '?? ?ANG M??N': 'BORROWED ITEMS',
    'Qu?n l? V?t ch?t': 'Facility Management',
    'Chi ti?t t? ??n': 'Submission detail',
    'Chi ti?t ??n': 'Submission detail',
    'Chi ti?t ??n v?': 'Department detail',
    'Chi ti?t ??a ?i?m': 'Location detail',
    'Chi ti?t ph? duy?t': 'Approval detail',
    'C?u h?nh lu?ng ph? duy?t': 'Approval workflow configuration',
    'TI?N ?? PH? DUY?T': 'APPROVAL PROGRESS',
    'GHI CH? PH? DUY?T': 'APPROVAL NOTE',
    'TH?I GIAN': 'TIME',
    '??A ?I?M': 'LOCATION',
    '??A ?I?M (PH?NG BAN B?N)': 'LOCATIONS (YOUR DEPARTMENT)',
    'V?T T?': 'ASSETS',
    'V?T T? (PH?NG BAN B?N)': 'ASSETS (YOUR DEPARTMENT)',
    'Ng??i g?i': 'Sender',
    'Ng??i giao': 'Handover by',
    'Ng??i k? duy?t': 'Approved by',
    'B?t ??u': 'Start',
    'K?t th?c': 'End',
    'H?n tr?:': 'Return deadline:',
    '??n v?': 'Department',
    'M? ??n v?': 'Department code',
    'M? lo?i': 'Category code',
    'M?': 'Code',
    '?VT': 'Unit',
    'S?c ch?a': 'Capacity',
    'Ng?y': 'Date',
    'Ch?n t?p ??nh k?m': 'Choose attachments',
    'Ch?a c? t?p n?o ???c ch?n': 'No files selected',
    'Ghi ch? g?i ph?ng n?y': 'Note for this department',
    'Th?m v?o lu?ng duy?t': 'Add to approval flow',
    'Th?m ng?y kh?c': 'Add another day',
    'B? ch?n': 'Deselect',
    'X?C NH?N': 'CONFIRM',
    'X?C NH?N T?O': 'CONFIRM CREATE',
    'M??n tr?': 'Borrow/Return',
    'Ti?u hao': 'Consumable',
    'S?n ph?m kh?ng c?n tr?': 'No return required',
    '?ANG DI?N RA': 'IN PROGRESS',
    'Tr?ng': 'Available',
    'Trang kh?ng t?n t?i': 'Page not found',
    'H? Th?ng Qu?n Tr?': 'Admin System',
    'Qu?n L? ??n V?': 'Unit Management',
    'C?ng Th?ng Tin': 'Information Portal',
    'QU?N L? LU?NG DUY?T': 'APPROVAL WORKFLOW MANAGEMENT',
    'QU?N L? PH?NG BAN': 'DEPARTMENT MANAGEMENT',
    'QU?N L? CSVC': 'FACILITY MANAGEMENT',
    'QU?N L? NG??I D?NG': 'USER MANAGEMENT',
    'QU?N L? ??N XU?T/NH?P KHO': 'WAREHOUSE REQUEST MANAGEMENT',
    'QU?N L? ?? NH?N': 'RECEIVED ITEM MANAGEMENT',
    'T?O T? TR?NH M?I': 'CREATE NEW SUBMISSION',
    'V?n h?nh h? th?ng & t? tr?nh': 'Operate workflows and submissions',
    'Quy?n h?n: Qu?n tr? vi?n': 'Role: Administrator',
    'Quy?n h?n: Nh?n s? ??n v?': 'Role: Department staff',
    'B?n ?? duy?t t? tr?nh n?y': 'You approved this submission',
    'B?n ?? t? ch?i t? tr?nh n?y': 'You rejected this submission',
    '??n ?? ???c k? duy?t - S?n s?ng b?n giao': 'Approved - Ready for handover',
    'G? b? c?u h?nh ph? duy?t?': 'Remove approval configuration?',
    'X?A C?U H?NH NGAY': 'DELETE CONFIGURATION NOW',
    'Tr?ng th?i ho?t ??ng': 'Active status',
    '?ang t?i danh s?ch vai tr?...': 'Loading roles...',
  };

  static const List<(String, String)> _prefixRules = [
    ('Xin ch?o, ', 'Hello, '),
    ('M? ??n v?: ', 'Department code: '),
    ('M? lo?i: ', 'Category code: '),
    ('Ng??i giao: ', 'Handover by: '),
    ('Nh?n t?i: ', 'Receive at: '),
    ('??n v?: ', 'Department: '),
    ('?p d?ng: ', 'Applies to: '),
    ('TH? T?: B??C ', 'ORDER: STEP '),
    ('B? kh?i lu?ng duy?t ', 'Remove from approval flow '),
    ('Nh?p y?u c?u, l?u ? c? th? cho ', 'Enter requests or notes for '),
    ('M??n ', 'Borrow '),
    ('L?ch m??n ', 'Borrow schedule for '),
  ];
}
