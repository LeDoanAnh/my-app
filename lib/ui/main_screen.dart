import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/ui/dynamic_dashboar_screen.dart';
import 'package:my_app/ui/home/home_screen.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_screen.dart';

import 'auth/profile_screen.dart';
import 'calendar/calendar_screen.dart';

class MainScreen extends StatefulWidget {
  final UserEntity user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final AnimationController _fabController;
  late final Animation<double> _fabScale;
  late final List<AnimationController> _navControllers;
  late final List<Animation<double>> _navScales;

  final _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Trang chủ'),
    _NavItem(icon: Icons.calendar_month_rounded, label: 'Lịch'),
    _NavItem(icon: Icons.assignment_rounded, label: 'Tờ trình'),
    _NavItem(icon: Icons.person_rounded, label: 'Cá nhân'),
  ];

  static const _screenMap = [0, 1, 3, 4];

  List<Widget> get _screens => [
    HomeScreen(user: widget.user),
    const CalendarScreen(),
    DynamicDashboardScreen(user: widget.user),
    SubmissionListScreen(user: widget.user),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _fabScale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
    );
    _navControllers = List.generate(
      _navItems.length,
          (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 80),
      ),
    );
    _navScales = _navControllers
        .map((c) => Tween<double>(begin: 1.0, end: 0.82).animate(
      CurvedAnimation(parent: c, curve: Curves.easeOut),
    ))
        .toList();
  }

  @override
  void dispose() {
    _fabController.dispose();
    for (final c in _navControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onNavTap(int navIndex) {
    HapticFeedback.selectionClick();
    _navControllers[navIndex]
        .forward()
        .then((_) => _navControllers[navIndex].reverse());
    setState(() => _selectedIndex = _screenMap[navIndex]);
  }

  void _onFabTap() {
    HapticFeedback.mediumImpact();
    _fabController.forward().then((_) => _fabController.reverse());
    setState(() => _selectedIndex = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      top: false,
      child: Container(
        height: 72 + 20 + bottomPadding,
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // ── Nav bar ──────────────────────────────────────────────────
            Positioned(
              bottom: bottomPadding > 0 ? bottomPadding : 12,
              left: 20,
              right: 20,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  // Dùng màu background của app, không hardcode đen
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.textGrey.withOpacity(0.12),
                    width: 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textDark.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.06),
                      blurRadius: 32,
                      spreadRadius: -4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0),
                    _buildNavItem(1),
                    const SizedBox(width: 60),
                    _buildNavItem(2),
                    _buildNavItem(3),
                  ],
                ),
              ),
            ),

            // ── FAB ──────────────────────────────────────────────────────
            Positioned(
              bottom: (bottomPadding > 0 ? bottomPadding : 12) + 18,
              child: GestureDetector(
                onTapDown: (_) => _fabController.forward(),
                onTapUp: (_) {
                  _fabController.reverse();
                  _onFabTap();
                },
                onTapCancel: () => _fabController.reverse(),
                child: ScaleTransition(
                  scale: _fabScale,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.secondary,
                          AppColors.primary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int navIndex) {
    final screenIndex = _screenMap[navIndex];
    final isSelected = _selectedIndex == screenIndex;
    final item = _navItems[navIndex];

    return ScaleTransition(
      scale: _navScales[navIndex],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onNavTap(navIndex),
        child: SizedBox(
          width: 52,
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 42,
                height: 34,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  item.icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textGrey.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: isSelected ? 14 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}