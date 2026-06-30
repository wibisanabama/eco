import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:eco/core/constants/app_colors.dart';
import 'package:eco/features/home/home_viewmodel.dart';
import 'package:eco/features/history/history_viewmodel.dart';
import 'package:eco/features/dashboard/dashboard_view.dart';
import 'package:eco/features/camera/camera_view.dart';
import 'package:eco/features/history/history_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeVM, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: homeVM.currentIndex,
              children: const [
                DashboardView(),
                CameraView(),
                HistoryView(),
              ],
            ),
            bottomNavigationBar: homeVM.currentIndex == 1
                ? null
                : _AnchoredBottomBar(
                    currentIndex: homeVM.currentIndex,
                    onTap: (index) {
                      HapticFeedback.mediumImpact();
                      homeVM.setIndex(index);
                      if (index == 2) {
                        context.read<HistoryViewModel>().loadHistory();
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}

/// Standard anchored bottom navigation bar with a floating center camera button.
class _AnchoredBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AnchoredBottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(38),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Home Tab
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.home_rounded,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                ),

                // Placeholder space for the floating center button
                const SizedBox(width: 80),

                // History Tab
                Expanded(
                  child: _NavBarItem(
                    icon: Icons.history_rounded,
                    activeIcon: Icons.history_rounded,
                    label: 'Riwayat',
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ),
              ],
            ),

            // Floating Center Camera Button
            Positioned(
              top: -24, // Raised above the dock
              left: 0,
              right: 0,
              child: Center(
                child: _CameraCenterButton(
                  isSelected: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.4),
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraCenterButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CameraCenterButton({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        width: isSelected ? 68 : 64,
        height: isSelected ? 68 : 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.accent : AppColors.secondary,
          boxShadow: [
            BoxShadow(
              color: (isSelected ? AppColors.accent : AppColors.secondary)
                  .withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Icon(
          Icons.photo_camera_rounded,
          color: isSelected ? AppColors.primary : Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
