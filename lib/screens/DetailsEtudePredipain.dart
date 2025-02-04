import 'package:flutter/material.dart';
import 'administrationpredipainpage.dart';
import 'SchemaRecherchePredipain.dart';

class DetailsEtudePredipain extends StatelessWidget {
  const DetailsEtudePredipain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de l'étude - Predipain"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Titre complet"),
            _buildInfoBox(
                "Évaluation des prises en charge thérapeutiques des patients lombalgiques chroniques dans leur parcours de soins."),
            _buildSectionTitle("Navigation"),
            _buildNavigationButton(
                context, "Administration", const AdministrationPredipainPage()),
            _buildNavigationButton(
                context, "Schéma de Recherche", const SchemaRecherchePredipain()),
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

  Widget _buildNavigationButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(title),
    );
  }
}
