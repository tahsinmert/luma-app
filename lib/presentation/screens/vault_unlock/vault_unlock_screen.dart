import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../../core/widgets/app_background.dart';
import '../../providers/vault_providers.dart';
import '../home/home_screen.dart';

class VaultUnlockScreen extends ConsumerStatefulWidget {
  final bool isCreating;

  const VaultUnlockScreen({
    super.key,
    this.isCreating = false,
  });

  @override
  ConsumerState<VaultUnlockScreen> createState() => _VaultUnlockScreenState();
}

class _VaultUnlockScreenState extends ConsumerState<VaultUnlockScreen> {
  final TextEditingController _passphraseController = TextEditingController();
  bool _showPassphraseInput = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isCreating) {
      _attemptBiometricUnlock();
    } else {
      _showPassphraseInput = true;
    }
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    super.dispose();
  }

  Future<void> _attemptBiometricUnlock() async {
    final biometric = ref.read(biometricServiceProvider);
    final isAvailable = await biometric.isBiometricAvailable();
    
    if (isAvailable) {
      await ref.read(vaultNotifierProvider.notifier).unlockWithBiometric();
      
      if (mounted) {
        final state = ref.read(vaultNotifierProvider);
        if (state.isUnlocked) {
          _navigateToHome();
        } else {
          setState(() {
            _showPassphraseInput = true;
          });
        }
      }
    } else {
      setState(() {
        _showPassphraseInput = true;
      });
    }
  }

  Future<void> _unlockWithPassphrase() async {
    final passphrase = _passphraseController.text;
    if (passphrase.isEmpty) {
      return;
    }

    if (widget.isCreating) {
      await ref.read(vaultNotifierProvider.notifier).createVault(passphrase);
    } else {
      await ref.read(vaultNotifierProvider.notifier).unlockWithPassphrase(passphrase);
    }

    if (mounted) {
      final state = ref.read(vaultNotifierProvider);
      if (state.isUnlocked) {
        _navigateToHome();
      }
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vaultState = ref.watch(vaultNotifierProvider);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Icon(
                    widget.isCreating ? Icons.add_circle_outline : Icons.lock_outline,
                    size: 80,
                    color: AppColors.primaryBlue,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                // Title
                Text(
                  widget.isCreating ? 'Create Your Vault' : 'Unlock Vault',
                  style: AppTypography.largeTitle,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Subtitle
                Text(
                  widget.isCreating
                      ? 'Choose a strong passphrase to secure your vault'
                      : 'Enter your passphrase or use biometric authentication',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                // Passphrase input
                if (_showPassphraseInput) ...[
                  GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: TextField(
                      controller: _passphraseController,
                      obscureText: true,
                      style: AppTypography.body,
                      decoration: const InputDecoration(
                        hintText: 'Enter passphrase',
                        hintStyle: TextStyle(color: AppColors.textTertiary),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _unlockWithPassphrase(),
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  if (vaultState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Text(
                        vaultState.error!,
                        style: AppTypography.footnote.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  
                  PrimaryButton(
                    label: widget.isCreating ? 'Create Vault' : 'Unlock',
                    onPressed: _unlockWithPassphrase,
                    isLoading: vaultState.isLoading,
                  ),
                ],
                
                if (!_showPassphraseInput && !widget.isCreating) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SecondaryButton(
                    label: 'Use Passphrase',
                    onPressed: () {
                      setState(() {
                        _showPassphraseInput = true;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
