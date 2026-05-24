// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanic_app/core/di/injection.dart';
import 'package:mechanic_app/presentation/features/auth/cubit/auth_cubit.dart';
import 'package:mechanic_app/presentation/features/auth/cubit/auth_state.dart';
import 'package:mechanic_app/presentation/features/auth/pages/login_page.dart';
import 'package:mechanic_app/presentation/features/main/pages/main_navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
      ],
      child: MaterialApp(
        title: 'Beresin Garasi - Mechanic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return MainNavigationPage(mechanicId: state.user.uid);
            }
            
            // PEMBARUAN: Menangani State Awal/Loading dengan halaman Splash Branding premium
            if (state is AuthLoading || state is AuthInitial) {
              return const _SplashLoadingView();
            }
            
            return const LoginPage();
          },
        ),
      ),
    );
  }
}

/// Komponen internal Splash Screen privat untuk kelancaran transisi loading session
class _SplashLoadingView extends StatelessWidget {
  const _SplashLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Premium Dark Slate
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.engineering_rounded,
                size: 64,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
          ],
        ),
      ),
    );
  }
}