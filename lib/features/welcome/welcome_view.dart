import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eco/core/constants/app_colors.dart';
import 'package:eco/core/constants/app_strings.dart';
import 'package:eco/features/auth/auth_viewmodel.dart';
import 'package:eco/features/splash/splash_view.dart'
    show heroIconSize, heroIconPad, heroIconRadius, heroFontSize, heroIconTextGap;

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final AnimationController _sheetController;
  late final Animation<Offset> _sheetSlide;

  // Login form
  final _usernameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  AuthViewModel? _authVM;

  @override
  void initState() {
    super.initState();

    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sheetSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutExpo,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sheetController.forward();
      }

      final authVM = context.read<AuthViewModel>();
      _authVM = authVM..addListener(_onAuthChanged);
      authVM.initialize();
    });
  }

  void _onAuthChanged() {
    final authVM = _authVM;
    if (authVM != null && authVM.isAuthenticated && mounted) {
      authVM.removeListener(_onAuthChanged);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sheetController.dispose();
    _usernameCtrl.dispose();
    _passCtrl.dispose();
    _authVM?.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _goBack() => _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sw = size.width;
    final double sh = size.height;

    // Hero tokens — IDENTICAL to SplashView
    final double iconSz = heroIconSize(sw);
    final double iconPad = heroIconPad(sw);
    final double iconRadius = heroIconRadius(sw);
    final double nameFontSz = heroFontSize(sw);
    final double iconTextGap = heroIconTextGap(sw);

    // Layout
    final double hPad = (sw * 0.072).clamp(20.0, 40.0);

    final double ar = sh / sw;
    final double cardTopRatio = ar > 1.9 ? 0.42 : ar > 1.6 ? 0.39 : 0.36;
    final double cardTop = (sh * cardTopRatio).clamp(220.0, sh * 0.48);
    final double cardRadius = (sw * 0.065).clamp(22.0, 32.0);

    final double sheetTopPad = (sh * 0.020).clamp(10.0, 22.0);
    final double indicatorBotPad = (sh * 0.014).clamp(8.0, 18.0);

    // Content tokens
    final double titleFontSz = (sw * 0.057).clamp(18.0, 26.0);
    final double subtitleFontSz = (sw * 0.034).clamp(12.0, 15.0);
    final double chipFontSz = (sw * 0.031).clamp(11.0, 14.0);
    final double btnHeight = (sh * 0.068).clamp(50.0, 62.0);
    final double btnFontSz = (sw * 0.042).clamp(14.0, 18.0);
    final double vGapSm = (sh * 0.013).clamp(8.0, 16.0);
    final double vGapMd = (sh * 0.024).clamp(14.0, 28.0);
    final double vGapLg = (sh * 0.030).clamp(18.0, 36.0);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.primary,
          ),

          // Top section — Logo + App Name
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: cardTop,
            child: SafeArea(
              bottom: false,
              child: Center(
                child: Hero(
                  tag: 'app_name',
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(iconPad),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(iconRadius),
                          ),
                          child: Icon(
                            Icons.eco,
                            color: Colors.white,
                            size: iconSz,
                          ),
                        ),
                        SizedBox(height: iconTextGap),
                        Text(
                          AppStrings.appName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: nameFontSz,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // White card sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: cardTop,
            child: SlideTransition(
              position: _sheetSlide,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cardRadius),
                    topRight: Radius.circular(cardRadius),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      SizedBox(height: sheetTopPad),

                      // Dot indicator
                      AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, _) {
                          final double page = _pageController.hasClients
                              ? (_pageController.page ?? _currentPage.toDouble())
                              : _currentPage.toDouble();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _dot(index: 0, page: page, sw: sw),
                              _dot(index: 1, page: page, sw: sw),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: indicatorBotPad),

                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (i) =>
                              setState(() => _currentPage = i),
                          children: [
                            _buildWelcomePage(
                              hPad: hPad,
                              titleFontSz: titleFontSz,
                              subtitleFontSz: subtitleFontSz,
                              chipFontSz: chipFontSz,
                              btnHeight: btnHeight,
                              btnFontSz: btnFontSz,
                              vGapSm: vGapSm,
                              vGapMd: vGapMd,
                              vGapLg: vGapLg,
                            ),
                            _buildLoginPage(
                              hPad: hPad,
                              titleFontSz: titleFontSz,
                              subtitleFontSz: subtitleFontSz,
                              btnHeight: btnHeight,
                              btnFontSz: btnFontSz,
                              vGapSm: vGapSm,
                              vGapMd: vGapMd,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required int index, required double page, required double sw}) {
    final double t = (1 - (page - index).abs()).clamp(0.0, 1.0);
    final double maxW = (sw * 0.072).clamp(20.0, 30.0);
    final double minW = (sw * 0.020).clamp(6.0, 9.0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: minW + (maxW - minW) * t,
      height: 5,
      decoration: BoxDecoration(
        color: Color.lerp(
          AppColors.onSurface.withValues(alpha: 0.15),
          AppColors.onSurface.withValues(alpha: 0.85),
          t,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // ─── PAGE 1: WELCOME ───────────────────────────────────────
  Widget _buildWelcomePage({
    required double hPad,
    required double titleFontSz,
    required double subtitleFontSz,
    required double chipFontSz,
    required double btnHeight,
    required double btnFontSz,
    required double vGapSm,
    required double vGapMd,
    required double vGapLg,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPad, vGapSm, hPad, vGapMd),
      child: Column(
        children: [
          Text(
            'Kenali kondisi lingkunganmu,\nbukan cuma sesaat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: titleFontSz,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              height: 1.3,
            ),
          ),
          SizedBox(height: vGapSm),
          Text(
            'Arahkan kamera, AI membaca udara, suhu, dan\n'
            'kelembapan sekitarmu — lalu memberi saran\n'
            'yang masuk akal untuk jangka panjang.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: subtitleFontSz,
              color: AppColors.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          SizedBox(height: vGapMd),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(Icons.qr_code_scanner, 'Scan Instan', chipFontSz),
              _chip(Icons.show_chart, 'Tren harian', chipFontSz),
              _chip(Icons.lightbulb_outline, 'Saran AI', chipFontSz),
            ],
          ),
          SizedBox(height: vGapLg),
          SizedBox(
            width: double.infinity,
            height: btnHeight,
            child: ElevatedButton(
              onPressed: () => _pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mulai Scan',
                    style: TextStyle(
                      fontSize: btnFontSz,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: btnFontSz + 2),
                ],
              ),
            ),
          ),
          SizedBox(height: vGapSm),
        ],
      ),
    );
  }

  // ─── PAGE 2: LOGIN ────────────────────────────────────
  Widget _buildLoginPage({
    required double hPad,
    required double titleFontSz,
    required double subtitleFontSz,
    required double btnHeight,
    required double btnFontSz,
    required double vGapSm,
    required double vGapMd,
  }) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(hPad, 0, hPad, vGapMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: _goBack,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.onSurface.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: (btnHeight * 0.32).clamp(15.0, 20.0),
                      color: AppColors.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),

              SizedBox(height: vGapSm),

              // Title
              Text(
                'Masuk ke akunmu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleFontSz,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  height: 1.3,
                ),
              ),
              SizedBox(height: vGapSm * 0.5),
              Text(
                'Masukkan username dan password untuk melanjutkan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: subtitleFontSz,
                  color: AppColors.onSurface.withValues(alpha: 0.55),
                  height: 1.45,
                ),
              ),

              SizedBox(height: vGapMd),

              // Username field
              _inputField(
                controller: _usernameCtrl,
                label: 'Username',
                icon: Icons.person_outline,
                keyboardType: TextInputType.text,
              ),

              SizedBox(height: vGapSm),

              // Password field
              _inputField(
                controller: _passCtrl,
                label: 'Password',
                icon: Icons.lock_outline,
                obscure: _obscurePass,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.onSurface.withValues(alpha: 0.45),
                  ),
                  onPressed: () =>
                      setState(() => _obscurePass = !_obscurePass),
                ),
              ),

              SizedBox(height: vGapMd),

              // Error
              if (authVM.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authVM.errorMessage!,
                          style: const TextStyle(
                              color: AppColors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: vGapSm),
              ],

              // Login button
              SizedBox(
                height: btnHeight,
                child: ElevatedButton(
                  onPressed: authVM.isLoading ? null : () => _submit(authVM),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    disabledBackgroundColor:
                        AppColors.primary.withValues(alpha: 0.55),
                  ),
                  child: authVM.isLoading
                      ? SizedBox(
                          width: btnHeight * 0.38,
                          height: btnHeight * 0.38,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: btnFontSz,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              SizedBox(height: vGapSm),

              // Navigate to Register page
              GestureDetector(
                onTap: () {
                  authVM.clearError();
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text(
                  'Belum punya akun? Daftar sekarang',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.width * 0.033)
                        .clamp(11.0, 14.0),
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: vGapSm),
            ],
          ),
        );
      },
    );
  }

  void _submit(AuthViewModel authVM) {
    final username = _usernameCtrl.text.trim();
    final pass = _passCtrl.text;

    if (username.isEmpty || pass.isEmpty) {
      return;
    }

    authVM.signIn(username, pass);
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    final double sw = MediaQuery.of(context).size.width;
    final double fontSize = (sw * 0.037).clamp(13.0, 15.5);
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: fontSize,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: fontSize * 0.93,
          color: AppColors.onSurface.withValues(alpha: 0.50),
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: AppColors.onSurface.withValues(alpha: 0.40),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _chip(IconData icon, String label, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 2, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}