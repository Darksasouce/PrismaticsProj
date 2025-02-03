import 'package:flutter/material.dart';
import 'ajout_patient.dart';
import 'ajout_etude.dart';
import 'formulaire_inclusion.dart';

class AccueilPage extends StatelessWidget {
  const AccueilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prismatics',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Ligne des boutons principaux
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(
                  context,
                  "Formulaire d'inclusion",
                  'assets/formulaire.png',
                  const FormulairePage(),
                ),
                _buildIconButton(
                  context,
                  "Ajout Patient",
                  'assets/Icon_patient.png',
                  const AjoutPatientPage(),
                ),
                _buildIconButton(
                  context,
                  "Ajout Étude",
                  'assets/Ajout_Etude.png',
                  const AjoutEtudePage(),
                ),
              ],
            ),
          ),
          // Grille des études
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 2, // Nombre d'études à afficher
              itemBuilder: (context, index) {
                String imagePath = index % 2 == 0
                    ? 'assets/Logo PREDIBACK 2.png'
                    : 'assets/logo-BoostDRG.png';
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtudePage(etudeIndex: index),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          imagePath,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Étude ${index + 1}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bas de page avec logos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/chupoitiers.png',
                height: 60,
              ),
              Image.asset(
                'assets/prismatics.png',
                height: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fonction pour créer un bouton avec icône
  Widget _buildIconButton(
      BuildContext context, String label, String imagePath, Widget page) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Image.asset(
        imagePath,
        height: 30,
        fit: BoxFit.contain,
      ),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

class EtudePage extends StatelessWidget {
  final int etudeIndex;
  const EtudePage({super.key, required this.etudeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Étude ${etudeIndex + 1}')),
      body: Center(
        child: Text(
          'Détails de l\'étude ${etudeIndex + 1}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
