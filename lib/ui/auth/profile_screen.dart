import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/ui/auth/blog/auth_bloc.dart';
import 'package:my_app/ui/auth/blog/auth_event.dart';
import 'package:my_app/ui/auth/blog/auth_state.dart';
import 'package:my_app/ui/item_widget/app_confirmation_dialog.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Design tokens — light & airy
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  // Page bg
  static const bg        = Color(0xFFF5F7FF);
  // Header gradient — soft blue-lavender
  static const hTop      = Color(0xFF5B8DEF);
  static const hMid      = Color(0xFF7B9FF5);
  static const hBot      = Color(0xFF9AB8FF);
  // Accent
  static const accent    = Color(0xFF4A7CF7);
  static const gold      = Color(0xFFFBBF24);
  // Card
  static const card      = Colors.white;
  static const divider   = Color(0xFFF0F2FA);
  // Text on header
  static const onHdr     = Colors.white;
  static const onHdrSub  = Color(0xCCFFFFFF);
  // Text on body
  static const textHi    = Color(0xFF1A2340);
  static const textMid   = Color(0xFF6B7A99);
  static const textLo    = Color(0xFFB0B8D0);
}

// ─────────────────────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
  }

  @override
  void dispose() {
    _entry.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is Unauthenticated) {
          showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (_) => AppConfirmationDialog(
              title: 'Thông báo',
              content: state.message ?? 'Phiên đăng nhập hết hạn',
              confirmText: 'OK',
              showCancel: false,
              onConfirm: () => ctx.go('/login'),
            ),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          String name      = 'Người dùng';
          String email     = '';
          String roleName  = '';
          bool isVerified  = false;

          if (state is Authenticated) {
            name       = state.user.fullName.isNotEmpty
                ? state.user.fullName
                : state.user.username;
            email      = state.user.email ?? '';
            roleName   = state.user.roles.isNotEmpty
                ? state.user.roles.first.roleName : '';
            isVerified = state.user.roles.isNotEmpty;
          }

          return Scaffold(
            backgroundColor: _C.bg,
            body: FadeTransition(
              opacity: CurvedAnimation(parent: _entry, curve: Curves.easeOut),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(ctx, name, email, roleName, isVerified),
                  _buildBody(ctx),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext ctx, String name, String email,
      String roleName, bool isVerified) {
    return SliverAppBar(
      expandedHeight: 290,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      elevation: 0,
      backgroundColor: _C.hTop,
      automaticallyImplyLeading: false,
      title: const Text('Hồ sơ',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Stack(alignment: Alignment.center, children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white, size: 24),
              onPressed: () {},
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: _C.gold,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _C.gold.withOpacity(0.7), blurRadius: 5)],
                ),
              ),
            ),
          ]),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _HeaderBg(
          name: name, email: email,
          roleName: roleName, isVerified: isVerified,
          pulse: _pulse,
        ),
      ),
    );
  }

  // ── BODY ──────────────────────────────────────────────────────────────────
  Widget _buildBody(BuildContext ctx) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 120),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _Section(title: 'Tài khoản', items: [
            _Item(Icons.person_outline_rounded,  const Color(0xFF4A7CF7), 'Thông tin cá nhân', 'Cập nhật hồ sơ của bạn',       () => ctx.push('/profile/edit')),
            _Item(Icons.shield_outlined,          const Color(0xFF22C55E), 'Bảo mật',          'Mật khẩu & xác thực 2 lớp',    () => ctx.push('/settings/security')),
          ]),
          const SizedBox(height: 22),
          _Section(title: 'Ứng dụng', items: [
            _Item(Icons.palette_outlined,         const Color(0xFFA855F7), 'Giao diện',        'Sáng / Tối / Theo hệ thống',   () => ctx.push('/settings/theme')),
            _Item(Icons.language_rounded,          const Color(0xFF06B6D4), 'Ngôn ngữ',         'Tiếng Việt',                   () => ctx.push('/settings/language')),
          ]),
          const SizedBox(height: 22),
          _Section(title: 'Hỗ trợ', items: [
            _Item(Icons.help_outline_rounded,      const Color(0xFFF97316), 'Trung tâm trợ giúp', 'FAQ & hướng dẫn sử dụng',  () => ctx.push('/help')),
            _Item(Icons.chat_bubble_outline_rounded,const Color(0xFF3B82F6), 'Liên hệ hỗ trợ',   'Chat trực tiếp với đội ngũ',() => ctx.push('/support/chat')),
          ]),
          const SizedBox(height: 30),
          _LogoutBtn(onTap: () => showDialog(
            context: ctx,
            builder: (_) => AppConfirmationDialog(
              title: 'Đăng xuất',
              content: 'Bạn có chắc muốn thoát tài khoản không?',
              confirmText: 'Đăng xuất',
              confirmColor: Colors.redAccent,
              onConfirm: () => ctx.read<AuthBloc>().add(LogoutPressed()),
            ),
          )),
          const SizedBox(height: 18),
          Center(child: Text('Phiên bản 2.2.3',
              style: TextStyle(color: _C.textLo, fontSize: 12, letterSpacing: 0.3))),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Header background — light gradient, center-aligned
// ─────────────────────────────────────────────────────────────────────────────
class _HeaderBg extends StatelessWidget {
  const _HeaderBg({
    required this.name, required this.email,
    required this.roleName, required this.isVerified,
    required this.pulse,
  });
  final String name, email, roleName;
  final bool   isVerified;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B9EFA), Color(0xFF92B8FF), Color(0xFFBDD1FF)],
        ),
      ),
      child: Stack(
        children: [
          // Soft decorative circles
          Positioned(top: -40, right: -50,
              child: _Blob(160, Colors.white, 0.08)),
          Positioned(bottom: 20, left: -40,
              child: _Blob(130, Colors.white, 0.06)),
          Positioned(top: 60, right: 30,
              child: _Blob(60, Colors.white, 0.07)),

          // Center all content
          Positioned.fill(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,  // ← CENTER
                children: [
                  const SizedBox(height: 32),

                  // ── Avatar ──────────────────────────────────────────
                  _PulsingAvatar(isVerified: isVerified, pulse: pulse),

                  const SizedBox(height: 14),

                  // ── Name ────────────────────────────────────────────
                  Text(name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                      shadows: [Shadow(color: Color(0x33000000), blurRadius: 8)],
                    ),
                  ),

                  // ── Email ───────────────────────────────────────────
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _C.onHdrSub,
                        fontSize: 13,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ── Role pill ───────────────────────────────────────
                  _Pill(
                    label: isVerified
                        ? (roleName.isNotEmpty ? roleName : 'Đã xác minh')
                        : 'Chưa xác minh',
                    verified: isVerified,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob(this.size, this.color, this.opacity);
  final double size; final Color color; final double opacity;
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withOpacity(opacity),
    ),
  );
}

class _PulsingAvatar extends StatelessWidget {
  const _PulsingAvatar({required this.isVerified, required this.pulse});
  final bool isVerified;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) {
        final p = (math.sin(pulse.value * 2 * math.pi) + 1) / 2;
        return SizedBox(
          width: 100, height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.20 + p * 0.15),
                    width: 2,
                  ),
                ),
              ),
              // Avatar circle
              Container(
                width: 82, height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.25),
                  border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.18 + p * 0.12),
                      blurRadius: 16 + p * 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.person_rounded, size: 44, color: Colors.white),
              ),
              // Badge
              if (isVerified)
                Positioned(
                  bottom: 4, right: 4,
                  child: Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: _C.gold.withOpacity(0.5), blurRadius: 6)],
                    ),
                    child: const Icon(Icons.verified_rounded, color: _C.gold, size: 16),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.verified});
  final String label; final bool verified;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.45), width: 1),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          verified ? Icons.auto_awesome_rounded : Icons.access_time_rounded,
          color: verified ? _C.gold : Colors.white70,
          size: 13,
        ),
        const SizedBox(width: 6),
        Text(label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Section + menu row
// ─────────────────────────────────────────────────────────────────────────────
class _Item {
  const _Item(this.icon, this.color, this.label, this.subtitle, this.onTap);
  final IconData icon; final Color color;
  final String label, subtitle; final VoidCallback onTap;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});
  final String title; final List<_Item> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10.5, fontWeight: FontWeight.w800,
              color: _C.textMid, letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _C.card,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: const Color(0xFF1A2340).withOpacity(0.06),
                  blurRadius: 18, offset: const Offset(0, 4)),
              BoxShadow(color: const Color(0xFF1A2340).withOpacity(0.03),
                  blurRadius: 4, offset: const Offset(0, 1)),
            ],
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              final isLast = i == items.length - 1;
              return Column(children: [
                _Row(item: items[i]),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 68),
                    child: Container(height: 0.8, color: _C.divider),
                  ),
              ]);
            }),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item});
  final _Item item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: item.color.withOpacity(0.06),
        highlightColor: item.color.withOpacity(0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label,
                    style: const TextStyle(
                      fontSize: 14.5, fontWeight: FontWeight.w600,
                      color: _C.textHi, letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(item.subtitle,
                      style: const TextStyle(fontSize: 12, color: _C.textMid, height: 1.3)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_right_rounded, color: _C.textMid, size: 17),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Logout button
// ─────────────────────────────────────────────────────────────────────────────
class _LogoutBtn extends StatelessWidget {
  const _LogoutBtn({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFFFCDD2), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.08),
              blurRadius: 14, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 19),
            SizedBox(width: 10),
            Text('Đăng xuất',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}