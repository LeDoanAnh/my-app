import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/l10n/app_localizations.dart';
import 'package:my_app/main.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/auth/blog/auth_event.dart';
import 'package:my_app/ui/auth/blog/auth_state.dart';
import 'package:my_app/ui/item_widget/app_card_container.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';
import 'package:my_app/l10n/ui_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          final apiMessage = state.message ?? l10n.logout;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AppConfirmationDialog(
              title: l10n.notification,
              content: apiMessage,
              confirmText: l10n.ok,
              showCancel: false,
              onConfirm: () {
                context.go('/login');
              },
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final userDisplayName = (state is Authenticated)
              ? state.user.username
              : l10n.unknownUser;

          return Material(
            color: const Color(0xFFF8F9FE),
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildUserCard(context, userDisplayName),
                        const SizedBox(height: 25),
                        _buildSectionTitle(l10n.settings),
                        _buildMenuItem(
                          Icons.settings_outlined,
                          l10n.settingsSecurity,
                        ),
                        const SizedBox(height: 20),
                        _buildSectionTitle(l10n.support),
                        _buildMenuItem(
                          Icons.help_outline_rounded,
                          l10n.helpCenter,
                        ),
                        const SizedBox(height: 30),
                        _buildSectionTitle(l10n.language),
                        _buildLanguageSelector(context),
                        _buildLogoutButton(context),
                        const SizedBox(height: 25),
                        Center(
                          child: TrText(
                            '${l10n.version} 2.2.3',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TrText(
              l10n.menu,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B3E),
              ),
            ),
            const Icon(
              Icons.notifications_none_rounded,
              size: 28,
              color: Color(0xFF0D1B3E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context)!;
    return AppCardContainer(
      children: [
        const Center(
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFFF0F1F5),
            child: Icon(Icons.person, size: 55, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TrText(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3E),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time_filled,
              size: 18,
              color: Colors.orange,
            ),
            const SizedBox(width: 6),
            TrText(
              l10n.unverified,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return TrText(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D1B3E),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF0D1B3E), size: 26),
            const SizedBox(width: 15),
            Expanded(
              child: TrText(
                title,
                style: const TextStyle(fontSize: 16, color: Color(0xFF0D1B3E)),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AppConfirmationDialog(
            title: l10n.logout,
            content: l10n.logoutConfirmContent,
            confirmText: l10n.logout,
            confirmColor: Colors.redAccent,
            onConfirm: () {
              context.read<AuthBloc>().add(LogoutPressed());
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF0D1B3E), width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: TrText(
            l10n.logout,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B3E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final isVietnamese = currentLocale.languageCode == 'vi';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildLanguageOption(
            context,
            label: l10n.vietnamese,
            isSelected: isVietnamese,
            onTap: () => MyApp.of(context).setLocale(const Locale('vi', 'VN')),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildLanguageOption(
            context,
            label: l10n.english,
            isSelected: !isVietnamese,
            onTap: () => MyApp.of(context).setLocale(const Locale('en', 'US')),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.language_rounded, color: Color(0xFF0D1B3E)),
            const SizedBox(width: 14),
            Expanded(
              child: TrText(
                label,
                style: const TextStyle(fontSize: 15, color: Color(0xFF0D1B3E)),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1A73E8),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
