import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> etudes = [];

  @override
  void initState() {
    super.initState();
    _fetchEtudes();
  }

  /// **Récupère toutes les études depuis la base Supabase**
  Future<void> _fetchEtudes() async {
    try {
      final response = await supabase.from('etude').select('*');

      if (response.isNotEmpty) {
        setState(() {
          etudes = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      debugPrint("❌ Erreur lors de la récupération des études : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: const Text("Accueil éditeur", style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("Formulaire d'Inclusion", Icons.article, const FormulairePage()),
                _buildButton("Ajout Patient", Icons.person, const AjoutPatientPage()),
                _buildButton("Ajout Étude", Icons.add_box, const AjoutEtudePage()),
              ],
            ),
            const SizedBox(height: 20),

            // **Affichage dynamique des études**
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Affichage en 4 colonnes
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: etudes.length,
                itemBuilder: (context, index) {
                  final etude = etudes[index];

                  return GestureDetector(
                    onTap: () {
                      // Ouvre la bonne page selon l'étude
                      Widget page;
                      switch (etude["nom"].toString().toLowerCase()) {
                        case "predipain":
                          page = const DetailsEtudePredipain();
                          break;
                        case "prediback":
                          page = const DetailsEtudePrediback();
                          break;
                        case "boostdrg":
                          page = const DetailsEtudeBoostDRG();
                          break;
                        default:
                          page = const DetailsEtudePredipain(); // Page par défaut
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => page),
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
                          Image.network(
                            etude["image_url"] ?? 'assets/default_study.png',
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 50),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            etude["nom"] ?? "Étude inconnue",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Catégorie: ${etude["categorie"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "N°: ${etude["num"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Investigateur: ${etude["investigateur"] ?? "N/A"}",
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

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

  /// **Boutons du haut**
  Widget _buildButton(String title, IconData icon, Widget page) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      icon: Icon(icon, color: Colors.black, size: 24),
      label: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: Colors.blue),
      ),
    );
  }
}
