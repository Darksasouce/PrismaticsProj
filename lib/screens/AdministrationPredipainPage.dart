import 'package:flutter/material.dart';

class AdministrationPredipainPage extends StatelessWidget {
  const AdministrationPredipainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration - Predipain'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("ADMINISTRATIF"),
            _buildInfoBox("CPP", "Initial : 20/12/2021"),
            _buildInfoBox("MS1", "Date : 29/06/2023"),
            _buildInfoBox("MS2", "Date : 14/06/2024"),
            _buildInfoBox("Assurance", "Non Applicable"),
            _buildSectionTitle("Documents de l’essai"),
            _buildInfoBox("Protocoles", "V2 du 01/02/2021"),
            _buildSectionTitle("BA"),
            _buildInfoBox("Tous les 3 mois", ""),
            _buildSectionTitle("Financements / Milestones"),
            _buildInfoBox("Prochain jalon", "XXX (Avril 2024)"),
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

  Widget _buildInfoBox(String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (content.isNotEmpty) Text(content),
        ],
      ),
    );
  }
}
