import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';


const isEnableApiLog = false;
const isEnableLog = kDebugMode;

final talker = TalkerFlutter.init(
  logger: logger,
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 100,
    useConsoleLogs: true,
  ),
);

final logger = TalkerLogger(
    settings: TalkerLoggerSettings(
        maxLineWidth: 20,
        enableColors: true,
        level: kDebugMode ? LogLevel.verbose : LogLevel.error));
