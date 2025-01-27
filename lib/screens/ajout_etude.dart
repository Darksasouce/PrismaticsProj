import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'accueil.dart';

class AjoutEtudePage extends StatefulWidget {
  const AjoutEtudePage({super.key});

  @override
  _AjoutEtudePageState createState() => _AjoutEtudePageState();
}

class _AjoutEtudePageState extends State<AjoutEtudePage> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;

  // Controllers for form fields
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _investigateurController = TextEditingController();
  final TextEditingController _promoteurController = TextEditingController();
  final TextEditingController _titreCompletController = TextEditingController();

  Future<void> _addStudy() async {
    if (_formKey.currentState!.validate()) {
      final currentContext = context; // Save context locally
      try {
        // Insert the data into the Supabase `etude` table
        await supabase.from('etude').insert({
          'nom': _nomController.text,
          'num': _numController.text,
          'categorie': _categorieController.text,
          'investigateur': _investigateurController.text,
          'promoteur': _promoteurController.text,
          'titre_complet': _titreCompletController.text,
          'nbpatient': 0, // Default value
        });

        // Success message
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Étude ajoutée avec succès !')),
        );

        // Navigate back to the home page
        Navigator.pushReplacement(
          currentContext,
          MaterialPageRoute(builder: (context) => const AccueilPage()),
        );
      } catch (e) {
        // Handle generic errors (if any)
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue, réessayez.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7E7E),
        title: const Text(
          "Ajout d'une étude",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField(label: "Nom de l'étude", controller: _nomController),
              _buildTextField(label: "N° de l'étude", controller: _numController),
              _buildTextField(label: "Catégorie", controller: _categorieController),
              _buildTextField(label: "Investigateur", controller: _investigateurController),
              _buildTextField(label: "Promoteur", controller: _promoteurController),
              _buildTextField(label: "Titre complet", controller: _titreCompletController),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _addStudy,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text(
                  "Valider",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire';
          }
          return null;
        },
      ),
    );
  }
}
