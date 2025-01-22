import 'package:flutter/material.dart';

class EtudePage extends StatelessWidget {
  final int etudeIndex;
  const EtudePage({super.key, required this.etudeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7E7EFF), // Couleur bleue
        title: Text(
          "Étude ${etudeIndex + 1}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, size: 30, color: Colors.white), // Icône Home
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'assets/prismatics.png', // Logo Prismatics
              width: 80,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'assets/chupoitiers.png', // Logo CHU Poitiers
              width: 50,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Icon_Etude1.png', // Par défaut, une icône d'étude
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              "Détails de l'étude ${etudeIndex + 1}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF7E7EFF), // Couleur bleue pour le bas de page
        height: 20,
      ),
    );
  }
}
