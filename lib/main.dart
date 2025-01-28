import 'package:flutter/material.dart';
import 'package:prismatics/screens/enregistrement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login.dart';
import 'screens/accueil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gcnbamsqhqgxqulmyrho.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdjbmJhbXNxaHFneHF1bG15cmhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2MjYzNzAsImV4cCI6MjA1MzIwMjM3MH0.u8ClI_1qMu8rzRJkPnazmTBorrm9G--fLFdotAi0tH8',
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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // Écran de chargement
        '/login': (context) => LoginPage(), // Page de connexion
        '/signup': (context) => SignupPage(), // Page d'inscription
        '/home': (context) => const AccueilPage(), // Page d'accueil
      },
    );
  }
}

// Écran de chargement initial
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkAuth(BuildContext context) async {
    // Vérifiez si l'utilisateur est connecté avec Supabase
    final session = Supabase.instance.client.auth.currentSession;
    await Future.delayed(const Duration(seconds: 2)); // Ajoute un effet de chargement

    if (session != null) {
      // Redirigez vers l'accueil si l'utilisateur est connecté
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Redirigez vers la page de connexion sinon
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vérifiez l'état de l'utilisateur au chargement
    _checkAuth(context);
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Indicateur de chargement
      ),
    );
  }
}
