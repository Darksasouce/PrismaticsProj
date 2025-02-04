import 'package:flutter/material.dart';

class DetailsEtudeBoostDRG extends StatelessWidget {
  const DetailsEtudeBoostDRG({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de l'étude - BoostDRG"),
        backgroundColor: Colors.blueGrey, // Couleur par défaut
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Titre complet"),
            _buildInfoBox("Informations non disponibles pour cette étude."),
            _buildSectionTitle("Description"),
            _buildInfoBox("Les détails de cette étude ne sont pas encore fournis."),
            _buildSectionTitle("Objectif"),
            _buildInfoBox("Pas d'objectif défini pour cette étude."),
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoBox(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(content),
    );
  }
}
