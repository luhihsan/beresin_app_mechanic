// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inisialisasi Firebase (Pastikan google-services.json sudah terpasang)
  await Firebase.initializeApp();
  
  // 2. Inisialisasi Service Locator Dependency Injection
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext Material) {
    return MaterialApp(
      title: 'Beresin Garasi - Mechanic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Engine Started! Architectures Ready.')),
      ),
    );
  }
}