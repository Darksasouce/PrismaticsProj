import 'package:flutter/material.dart';
import 'schema_recherche.dart';

class AdministrationPage extends StatelessWidget {
  const AdministrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administration et Financement"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📝 Administratif",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSection("CPP", "Date : 22/12/2021", "Commentaires :"),
            const SizedBox(height: 10),
            _buildSection("ANSM", "Rapport : Pas commencé", ""),
            const SizedBox(height: 10),
            _buildSection("Assurance", "Non Applicable", ""),
            const SizedBox(height: 10),
            _buildSection("Documents de l'essai", "Protocoles, Réunions, Notes", ""),
            const SizedBox(height: 10),
            _buildSection("Financements / Milestones", "Budget : 10M€", ""),
            const Spacer(),

            // Bouton pour aller au schéma de recherche
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SchemaRecherchePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text("🔍 Voir le Schéma de Recherche", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String subtitle, String comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(fontSize: 16)),
        if (comment.isNotEmpty)
          Text(comment, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
        const Divider(),
      ],
    );
  }
}
