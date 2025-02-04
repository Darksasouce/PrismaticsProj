import 'package:flutter/material.dart';

class SchemaRechercheBoostDRG extends StatelessWidget {
  const SchemaRechercheBoostDRG({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schéma de la Recherche - BoostDRG'),
        backgroundColor: Colors.blueGrey,
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
            const Text("Informations non disponibles"),
            const SizedBox(height: 16),

            // Étapes du processus (par défaut)
            _buildSectionTitle("🛠 Étapes du processus"),
            _buildListTile("Visite de sélection"),
            _buildListTile("Phase d’implantation"),
            _buildListTile("Visite de suivi"),
            const SizedBox(height: 16),

            // Critères de jugement (par défaut)
            _buildSectionTitle("📊 Critères de jugement"),
            _buildListTile("Indicateurs de douleur"),
            _buildListTile("Tests d’efficacité"),
            _buildListTile("Évaluation globale"),
            const SizedBox(height: 32),

            // Pas de navigation vers Administration car non défini
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
