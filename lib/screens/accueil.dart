import 'package:flutter/material.dart';
import 'detailsetudepredipain.dart';
import 'detailsetudeprediback.dart';
import 'DetailsEtudeBoostDRG.dart';
import 'ajout_patient.dart';
import 'ajout_etude.dart';
import 'formulaire_inclusion.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({super.key});

  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final List<Map<String, dynamic>> etudes = [
    {"nom": "Étude sur Prediback", "page": const DetailsEtudePrediback(), "image": "assets/prediback.png"},
    {"nom": "Étude sur Predipain", "page": const DetailsEtudePredipain(), "image": "assets/predipain.png"},
    {"nom": "Étude sur BoostDRG", "page": const DetailsEtudeBoostDRG(), "image": "assets/default_study.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300, // Fond bleu
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300, // Barre grise
        title: const Text("Accueil éditeur", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // **Boutons du haut agrandis**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("Formulaire d'Inclusion", Icons.article, const FormulairePage()),
                _buildButton("Ajout Patient", Icons.person, const AjoutPatientPage()),
                _buildButton("Ajout Étude", Icons.add_box, const AjoutEtudePage()),
              ],
            ),
            const SizedBox(height: 20),

            // **Grille des études**
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 colonnes comme dans ton image
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: 12, // 3 études + 9 cases vides
                itemBuilder: (context, index) {
                  if (index < etudes.length) {
                    final etude = etudes[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => etude["page"]),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              etude["image"],
                              fit: BoxFit.contain,
                              width: 80,
                              height: 80,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              etude["nom"],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // **Case vide**
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }
                },
              ),
            ),

            // **Logos en bas**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/chupoitiers.png', height: 60),
                Image.asset('assets/prismatics.png', height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// **Création des boutons du haut (Agrandis)**
  Widget _buildButton(String title, IconData icon, Widget page) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      icon: Icon(icon, color: Colors.black, size: 24),
      label: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Boutons plus grands
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: Colors.blue),
      ),
    );
  }
}
