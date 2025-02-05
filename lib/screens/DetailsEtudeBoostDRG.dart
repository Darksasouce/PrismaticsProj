import 'package:flutter/material.dart';
import 'administrationboostdrgpage.dart';
import 'schemarechercheboostdrg.dart';
import 'chart_boostdrg.dart'; // 🔹 Import du graphique

class DetailsEtudeBoostDRG extends StatelessWidget {
  const DetailsEtudeBoostDRG({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de l'étude - Boost DRG"),
        backgroundColor: Colors.orange, // 🔸 Couleur spécifique à Boost DRG
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Titre complet"),
            _buildInfoBox(
                "Étude sur la stimulation du ganglion spinal dorsal (DRG) pour les douleurs neuropathiques chroniques."),

            _buildSectionTitle("Navigation"),
            _buildNavigationButton(
                context, "Administration", const AdministrationBoostDRGPage()),
            _buildNavigationButton(
                context, "Schéma de Recherche", const SchemaRechercheBoostDRG()),

            const SizedBox(height: 20),

            _buildSectionTitle("Évolution des inclusions"),

            // 🔹 Intégration directe du graphique
            const Expanded(
              child: BoostDRGChart(),
            ),

            const SizedBox(height: 20),
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
