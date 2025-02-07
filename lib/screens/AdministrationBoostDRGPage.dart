import 'package:flutter/material.dart';

class AdministrationBoostDRGPage extends StatelessWidget {
  const AdministrationBoostDRGPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administration et Financement - BoostDRG"),
        backgroundColor: Colors.blueGrey, // Couleur spécifique pour BoostDRG
      ),
      body: SingleChildScrollView( // 🔹 Ajout pour éviter les débordements
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("📝 Administratif"),
            _buildInfoBox("CPP", "Date : N/A\nCommentaires : Aucun renseignement disponible"),
            _buildInfoBox("ANSM", "Rapport : Pas commencé"),
            _buildInfoBox("Assurance", "Non Applicable"),

            const SizedBox(height: 16),
            _buildSectionTitle("📄 Documents de l'essai"),
            _buildInfoBox("Protocole", "Aucune information spécifique"),
            _buildInfoBox("Réunions", "Pas de réunions planifiées"),
            _buildInfoBox("Notes", "Aucune note disponible"),

            const SizedBox(height: 16),
            _buildSectionTitle("💰 Financements / Milestones"),
            _buildInfoBox("Budget", "Informations financières non disponibles"),

            const SizedBox(height: 20), // 🔹 Ajout d'un espace en bas

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Retour"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20), // 🔹 Ajout d'un espace pour éviter tout débordement
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoBox(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
