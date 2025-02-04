import 'package:flutter/material.dart';
import 'administration.dart';

class SchemaRecherchePage extends StatelessWidget {
  const SchemaRecherchePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schéma de la Recherche"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📌 Schéma de la Recherche",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("ARC Promoteur : Lucie LAMPERT"),
            const Text("ARC Investigateur : Bertille LORGUEUX et Sandrine BARON"),
            const SizedBox(height: 10),

            const Text("🔍 Étapes du processus :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildStep("📅 Visite de sélection"),
            _buildStep("🧪 Visite d'implantation (Électrode, Phase test, Boîtier)"),
            _buildStep("🩺 Visite M1"),
            _buildStep("📋 Visite M3"),
            _buildStep("📌 Visite M6"),

            const SizedBox(height: 20),
            const Text("📊 Critères de jugement :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildCriteria("📑 ODI : ≥30%"),
            _buildCriteria("📑 EQ-5D : ≥0,2 pts"),
            _buildCriteria("📑 HADS : ≥1,4 pts"),
            _buildCriteria("📊 Cartographie de la douleur : ≥30 cm²"),
            _buildCriteria("📊 EVA : ≥50%"),

            const Spacer(),

            // Bouton pour revenir à l'administration
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdministrationPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text("📄 Voir Administration", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.blue),
          const SizedBox(width: 8),
          Text(step, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCriteria(String criteria) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.assignment, color: Colors.orange),
          const SizedBox(width: 8),
          Text(criteria, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
