import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_colors.dart';
import 'package:my_app/domain/entities/user_entity.dart';
import 'package:my_app/ui/dynamic_dashboar_screen.dart';
import 'package:my_app/ui/home/home_screen.dart';
import 'package:my_app/ui/submission/submission_list/submission_list_screen.dart';

import 'auth/profile_screen.dart';
import 'calendar/calendar_screen.dart';

class MainScreen extends StatefulWidget {
  UserEntity user;
  MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldBg,
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      height: 110,
      padding: const EdgeInsets.only(bottom: 25, left: 16, right: 16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Lớp nền trắng bo góc của Bottom Bar
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textDark.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.home_rounded),
                _buildNavItem(1, Icons.widgets_rounded),
                const SizedBox(width: 55),
                _buildNavItem(3, Icons.assignment_rounded),
                _buildNavItem(4, Icons.person_rounded),
              ],
            ),
          ),

          // Nút Floating Action Button (Dấu cộng) ở giữa
          Positioned(
            top: 0,
            child: GestureDetector(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) {
                _controller.reverse();
                setState(
                  () => _selectedIndex = 2,
                ); // Chuyển sang CreateSubmissionScreen
              },
              onTapCancel: () => _controller.reverse(),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.secondary, Color(0xFFC7D2FE)],
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    bool isSelected = _selectedIndex == index;
    return IconButton(
      onPressed: () => setState(() => _selectedIndex = index),
      icon: Icon(
        icon,
        size: 28,
        color: isSelected
            ? AppColors.primary
            : AppColors.textGrey.withOpacity(0.5),
      ),
    );
  }
}
