import 'package:flutter/material.dart';
import 'administrationpredipainPage.dart';
import 'administrationpredibackPage.dart';

class DetailsEtudePage extends StatelessWidget {
  final String etude;

  const DetailsEtudePage({super.key, required this.etude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'étude - $etude'),
        backgroundColor: _getColorForStudy(etude),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Titre complet"),
            _buildInfoBox(
                "Description",
                etude == "Prediback"
                    ? "Identification des facteurs prédictifs des réponses et stratification des patients implantés..."
                    : etude == "Predipain"
                    ? "Évaluation des prises en charge thérapeutiques des patients lombalgiques chroniques..."
                    : "Informations non disponibles"),
            _buildSectionTitle("Navigation"),
            _buildNavigationButton(
              context,
              "Administration",
              etude == "Predipain" ? const AdministrationPredipainPage() : const AdministrationPredibackPage(),
            ),
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

  Widget _buildNavigationButton(BuildContext context, String title, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Text(title),
    );
  }

  Color _getColorForStudy(String study) {
    switch (study) {
      case "Prediback":
        return Colors.purple;
      case "Predipain":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }
}
