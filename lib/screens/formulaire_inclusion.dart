import 'package:flutter/material.dart';
import 'package:prismatics/screens/details_etude.dart';

class FormulairePage extends StatelessWidget {
  const FormulairePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700), // Couleur jaune
        title: const Text(
          "Formulaire d'inclusion",
          style: TextStyle(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Formulaire d'inclusion",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(6, (index) {
              return Column(
                children: [
                  _buildTextField(label: "Taille (cm)"),
                  const SizedBox(height: 16),
                  _buildTextField(label: "Poids (kg)"),
                  const SizedBox(height: 16),
                  _buildTextField(label: "Âge"),
                  const SizedBox(height: 16),
                ],
              );
            }),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EtudePage(etudeIndex: 0),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300, // Couleur bouton gris
                foregroundColor: Colors.black, // Texte noir
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text(
                "Valider",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFD700), // Couleur jaune pour le bas de page
        height: 20,
      ),
    );
  }

  // Widget pour un champ texte
  Widget _buildTextField({required String label}) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}
