import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Uint8List? _selectedImage;
  String? _imageUrl;
  String? _imageName;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _categorieController = TextEditingController();
  final TextEditingController _investigateurController = TextEditingController();
  final TextEditingController _promoteurController = TextEditingController();
  final TextEditingController _titreCompletController = TextEditingController();

  /// Ouvre la galerie et sélectionne une image
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = imageBytes;
        _imageName = 'etudes_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }

  /// Upload l’image sur Supabase Storage et récupère son URL publique
  Future<void> _uploadImage() async {
    if (_selectedImage == null || _imageName == null) return;

    try {
      await supabase.storage.from('etudes_images').uploadBinary(_imageName!, _selectedImage!);
      final String publicUrl = supabase.storage.from('etudes_images').getPublicUrl(_imageName!);

      setState(() {
        _imageUrl = publicUrl;
      });
    } catch (e) {
      debugPrint('❌ Erreur d\'upload: $e');
    }
  }

  /// **Ajoute une nouvelle étude à la base de données**
  Future<void> _addStudy() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_selectedImage != null) {
          await _uploadImage();
        }

        if (_imageUrl == null || _imageUrl!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez choisir une image avant d\'ajouter une étude.')),
          );
          return;
        }

        final newEtude = {
          'nom': _nomController.text,
          'num': _numController.text,
          'categorie': _categorieController.text,
          'investigateur': _investigateurController.text,
          'promoteur': _promoteurController.text,
          'titre_complet': _titreCompletController.text,
          'image_url': _imageUrl!,
          'nbpatient': 0,
        };

        await supabase.from('etude').insert(newEtude);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Étude ajoutée avec succès !')),
        );

        // **Navigue vers la page d'accueil et met à jour la liste des études**
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccueilPage()),
        );
      } catch (e) {
        debugPrint('❌ Erreur lors de l\'ajout de l\'étude: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'ajout de l\'étude.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔹 **Bandeau Vert en Haut**
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.green,
            child: const Center(
              child: Text(
                "Ajout d'une nouvelle étude",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 🔹 **Formulaire**
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(label: "Nom de l'étude", controller: _nomController),
                    _buildTextField(label: "N° de l'étude", controller: _numController),
                    _buildTextField(label: "Catégorie", controller: _categorieController),
                    _buildTextField(label: "Investigateur", controller: _investigateurController),
                    _buildTextField(label: "Promoteur", controller: _promoteurController),
                    _buildTextField(label: "Titre complet", controller: _titreCompletController),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text("📷 Choisir une image depuis la galerie"),
                    ),

                    const SizedBox(height: 16),
                    if (_imageUrl != null)
                      Image.network(
                        _imageUrl!,
                        height: 100,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50),
                      ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addStudy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: const Text(
                        "✅ Valider",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        validator: (value) => value == null || value.isEmpty ? '⚠ Ce champ est obligatoire' : null,
      ),
    );
  }
}
