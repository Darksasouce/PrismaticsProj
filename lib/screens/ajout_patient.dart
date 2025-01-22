import 'package:flutter/material.dart';
import 'accueil.dart';

class AjoutPatientPage extends StatelessWidget {
  const AjoutPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7E7E), // Couleur rouge
        title: const Text(
          "Ajout d'un patient",
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
              'assets/prismatics.png',
              width: 80,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Image.asset(
              'assets/chupoitiers.png',
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
            _buildTextField(label: "Identifiant du patient"),
            const SizedBox(height: 16),
            _buildDropdownField(label: "Nom de l'étude"),
            const SizedBox(height: 16),
            _buildTextField(label: "Date d'inclusion"),
            const SizedBox(height: 16),
            _buildTextField(label: "Fin d'inclusion"),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Patient ajouté avec succès !')),
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

  Widget _buildDropdownField({required String label}) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      items: const [
        DropdownMenuItem(value: "Etude 1", child: Text("Etude 1")),
        DropdownMenuItem(value: "Etude 2", child: Text("Etude 2")),
        DropdownMenuItem(value: "Etude 3", child: Text("Etude 3")),
      ],
      onChanged: (value) {
        // Action lorsque l'utilisateur sélectionne une option
      },
    );
  }
}
