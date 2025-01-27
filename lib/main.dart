import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/accueil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gcnbamsqhqgxqulmyrho.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdjbmJhbXNxaHFneHF1bG15cmhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2MjYzNzAsImV4cCI6MjA1MzIwMjM3MH0.u8ClI_1qMu8rzRJkPnazmTBorrm9G--fLFdotAi0tH8',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prismatics',
      initialRoute: '/',
      routes: {
        '/': (context) => const AccueilPage(),
      },
    );
  }
}
