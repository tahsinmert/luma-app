import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/app_background.dart';
import '../vault_unlock/vault_unlock_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.lock_outline,
      title: 'Privacy First',
      description:
          'Your thoughts, memories, and files stay completely private. Zero servers, zero tracking, zero compromises.',
    ),
    _OnboardingPage(
      icon: Icons.shield_outlined,
      title: 'On-Device Vault',
      description:
          'Military-grade AES-256 encryption protects everything. Only you hold the keys, secured by Face ID.',
    ),
    _OnboardingPage(
      icon: Icons.auto_awesome_outlined,
      title: 'Your Personal Space',
      description:
          'Journal, voice notes, documents, and photos—all in one beautiful, searchable vault.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.huge),
                
                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _PageIndicator(
                      isActive: index == _currentPage,
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.huge),
                
                // Pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingPageView(page: _pages[index]);
                    },
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                // CTA Button
                PrimaryButton(
                  label: 'Create Vault',
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const VaultUnlockScreen(isCreating: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon in glass card
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Icon(
            page.icon,
            size: 80,
            color: AppColors.primaryBlue,
          ),
        ),
        
        const SizedBox(height: AppSpacing.xxl),
        
        // Title
        Text(
          page.title,
          style: AppTypography.largeTitle,
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            page.description,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : AppColors.softGray,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }
}
