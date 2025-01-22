import 'package:flutter/material.dart';
import 'screens/accueil.dart';
import 'screens/ajout_patient.dart';
import 'screens/ajout_etude.dart';
import 'screens/formulaire_inclusion.dart';

void main() {
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
        '/formulaire': (context) => const FormulairePage(),
        '/ajout_patient': (context) => const AjoutPatientPage(),
        '/ajout_etude': (context) => const AjoutEtudePage(),
        '/etude_details': (context) => const EtudePage(etudeIndex: 0), // Exemple
      },
    );
  }
}
