import 'package:flutter/material.dart';
import 'package:eco/core/constants/app_colors.dart';
import 'package:eco/core/constants/app_strings.dart';
import 'package:eco/features/splash/splash_viewmodel.dart';

/// Shared responsive tokens — used by WelcomeView too
/// so Hero 'app_name' flies smoothly (identical sizes).
double heroIconSize(double sw) => (sw * 0.072).clamp(24.0, 36.0);
double heroIconPad(double sw) => (sw * 0.030).clamp(10.0, 16.0);
double heroIconRadius(double sw) => (sw * 0.038).clamp(14.0, 20.0);
double heroFontSize(double sw) => (sw * 0.052).clamp(18.0, 26.0);
double heroIconTextGap(double sw) => (sw * 0.020).clamp(6.0, 12.0);

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  final SplashViewModel _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    await _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    final route = await _viewModel.getInitialRoute();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sw = size.width;

    // Hero tokens (identical with WelcomeView)
    final double iconSz = heroIconSize(sw);
    final double iconPad = heroIconPad(sw);
    final double iconRadius = heroIconRadius(sw);
    final double nameFontSz = heroFontSize(sw);
    final double iconTextGap = heroIconTextGap(sw);

    final double taglineFontSz = (sw * 0.030).clamp(11.0, 13.5);
    final double taglineHPad = (sw * 0.10).clamp(24.0, 70.0);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primary,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo + App Name — Hero to welcome
              Hero(
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

              const SizedBox(height: 16),

              /// Tagline
              Padding(
                padding: EdgeInsets.symmetric(horizontal: taglineHPad),
                child: Text(
                  AppStrings.appTagline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: taglineFontSz,
                    color: Colors.white.withValues(alpha: 0.60),
                    letterSpacing: 0.2,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}