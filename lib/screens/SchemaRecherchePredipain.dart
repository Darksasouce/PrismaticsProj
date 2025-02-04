import 'package:flutter/material.dart';
import 'administrationpredipainpage.dart';

class SchemaRecherchePredipain extends StatelessWidget {
  const SchemaRecherchePredipain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schéma de la Recherche - Predipain'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📜 Schéma de la Recherche",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("ARC Promoteur : Lucie LAMPERT"),
            const Text("ARC Investigateur : Bertille LORGEUX et Sandrine BARON"),
            const SizedBox(height: 16),

            // Étapes du processus
            _buildSectionTitle("🛠 Étapes du processus"),
            _buildListTile("Visite de sélection"),
            _buildListTile("Visite d'implantation (Phase test, Boîtier)"),
            _buildListTile("Visite M1"),
            _buildListTile("Visite M3"),
            _buildListTile("Visite M6"),
            const SizedBox(height: 16),

            // Critères de jugement
            _buildSectionTitle("📊 Critères de jugement"),
            _buildListTile("ODI : ≥30%"),
            _buildListTile("EQ-5D : ≥0,2 pts"),
            _buildListTile("HADS : ≥1,4 pts"),
            _buildListTile("Cartographie de la douleur : ≥30 cm²"),
            _buildListTile("EVA : ≥50%"),
            const SizedBox(height: 32),

            // Bouton de navigation vers Administration
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdministrationPredipainPage()),
                  );
                },
                icon: const Icon(Icons.article),
                label: const Text("Voir Administration"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
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

  Widget _buildListTile(String text) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.blue),
      title: Text(text),
    );
  }
}
