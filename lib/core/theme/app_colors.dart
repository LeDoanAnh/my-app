import 'package:flutter/material.dart';

class AppColors {
  // Màu chủ đạo - Indigo hiện đại
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color secondary = Color(0xFFEEF2FF);

  // Bổ sung màu cho hiệu ứng Gradient & Màu mè
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color softBlue = Color(0xFFE0E7FF);
  static const Color glassWhite = Color(0x26FFFFFF); // Trắng mờ 15%

  // Màu chữ và nền
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF64748B);
  static const Color background = Colors.white;
  static const Color fieldBg = Color(0xFFF1F5F9); // Nền xám xanh nhạt
  static const Color borderSubtle = Color(0xFFE2E8F0);

  // Màu trạng thái
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Định nghĩa sẵn Gradient để dùng cho nhanh
  static const LinearGradient heroGradient = LinearGradient(
    colors: [primary, accentViolet, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
