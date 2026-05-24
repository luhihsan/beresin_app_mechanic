// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'presentation/features/auth/cubit/auth_cubit.dart';
import 'presentation/features/auth/cubit/auth_state.dart';
import 'presentation/features/auth/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Firebase Core
  await Firebase.initializeApp();
  
  // 2. Inisialisasi Dependency Injection (GetIt)
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Menyediakan AuthCubit secara global ke seluruh pohon widget aplikasi
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
        // Menggunakan BlocBuilder untuk menentukan skrin awal berdasarkan status login terakhir
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Dashboard Mekanik'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => context.read<AuthCubit>().logout(),
                    )
                  ],
                ),
                body: Center(
                  child: Text('Halo Mekanik: ${state.user.name}\nEngine is Active!'),
                ),
              );
            }
            
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Jika Unauthenticated, arahkan paksa ke halaman login
            return const LoginPage();
          },
        ),
      ),
    );
  }
}