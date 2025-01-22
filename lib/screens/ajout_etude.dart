import 'package:flutter/material.dart';
import 'accueil.dart';

class AjoutEtudePage extends StatelessWidget {
  const AjoutEtudePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7E7E), // Couleur rouge
        title: const Text(
          "Ajout d'une étude",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccueilPage()),
            );
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            _buildTextField(label: "Nom de l'étude"),
            _buildTextField(label: "N° de l'étude"),
            _buildTextField(label: "Catégorie"),
            _buildTextField(label: "Investigateur"),
            _buildTextField(label: "Promoteur"),
            _buildTextField(label: "Logo"),
            _buildTextField(label: "Titre complet"),
            _buildTextField(label: "Objectif principal"),
            _buildTextField(label: "Objectif(s) secondaire(s)"),
            _buildTextField(label: "Nom sponsor"),
            _buildTextField(label: "Logo sponsor"),
            _buildTextField(label: "Durée suivi"),
            _buildTextField(label: "Période inclusion"),
            _buildTextField(label: "Durée totale"),
            _buildTextField(label: "Date première inclusion"),
            _buildTextField(label: "Date dernière inclusion"),
            _buildTextField(label: "Rapport"),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Étude ajoutée avec succès !')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
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
        color: const Color(0xFFFF7E7E),
        height: 20,
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
