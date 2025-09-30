import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/vault_unlock/vault_unlock_screen.dart';
import 'presentation/providers/vault_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: WhisperJournalApp(),
    ),
  );
}

class WhisperJournalApp extends ConsumerWidget {
  const WhisperJournalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Whisper Journal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

/// Splash screen that determines initial route
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Wait a moment for smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if vault exists
    final vaultNotifier = ref.read(vaultNotifierProvider.notifier);
    final vaultExists = await vaultNotifier.checkVaultExists();

    if (!mounted) return;

    if (vaultExists) {
      // Navigate to unlock screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const VaultUnlockScreen(),
        ),
      );
    } else {
      // Navigate to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
