import 'package:flutter/material.dart';
import 'administrationpredibackpage.dart';
import 'schemarechercheprediback.dart';



class DetailsEtudePrediback extends StatelessWidget {
  const DetailsEtudePrediback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de l'étude - Prediback"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Titre complet"),
            _buildInfoBox(
                "Identification des facteurs prédictifs des réponses et stratification des patients implantés avec un dispositif médical spécifique."),
            _buildSectionTitle("Navigation"),
            _buildNavigationButton(
                context, "Administration", const AdministrationPredibackPage()),
            _buildNavigationButton(
                context, "Schéma de Recherche", const SchemaRecherchePrediback()),
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
