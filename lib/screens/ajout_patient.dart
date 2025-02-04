import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'accueil.dart';

class AjoutPatientPage extends StatefulWidget {
  const AjoutPatientPage({super.key});

  @override
  _AjoutPatientPageState createState() => _AjoutPatientPageState();
}

class _AjoutPatientPageState extends State<AjoutPatientPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  List<String> _etudes = [];
  String? _selectedEtude;
  String _patientId = "";
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchEtudes();
  }

  /// **Récupère la liste des études valides depuis Supabase**
  Future<void> _fetchEtudes() async {
    debugPrint("🔍 Récupération des études valides...");
    try {
      final response = await supabase.from('etude').select('nom'); // ✅ Correction ici
      debugPrint("✅ Études récupérées : $response");

      if (response.isNotEmpty) {
        setState(() {
          _etudes = List<String>.from(response.map((e) => e['nom']));
        });
      }
    } catch (e) {
      debugPrint("❌ Erreur lors de la récupération des études : $e");
    }
  }

  /// **Vérifie si l'étude sélectionnée est valide selon la base**
  bool _isValidStudy(String? study) {
    return _etudes.contains(study);
  }

  /// **Ouvre un DatePicker pour sélectionner la date d'inclusion**
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// **Ajoute un patient dans la base de données**
  Future<void> _addPatient() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final currentContext = context;

      try {
        if (!_isValidStudy(_selectedEtude)) {
          throw Exception("L'étude sélectionnée n'est pas valide.");
        }

        // Vérifier si l'ID est un entier valide
        int? patientIdInt;
        if (_patientId.isNotEmpty) {
          patientIdInt = int.tryParse(_patientId);
          if (patientIdInt == null) {
            throw Exception("L'ID du patient doit être un nombre entier.");
          }
        } else {
          patientIdInt = DateTime.now().millisecondsSinceEpoch; // Générer un ID unique
        }

        String inclusionDate = _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : DateFormat('yyyy-MM-dd').format(DateTime.now());

        debugPrint("📝 Tentative d'insertion du patient...");
        debugPrint("➡ ID: $patientIdInt, Étude: $_selectedEtude, Date: $inclusionDate");

        // Insérer le patient dans la BDD
        await supabase.from('patients').insert({
          'id': patientIdInt,
          'etude': _selectedEtude,
          'inclusion_date': inclusionDate,
        });

        debugPrint("✅ Patient ajouté avec succès.");

        // **Mise à jour du compteur de patients**
        if (_selectedEtude != null) {
          debugPrint("🔄 Mise à jour du compteur de patients pour l'étude $_selectedEtude...");

          final etudeResponse = await supabase
              .from('etude')
              .select('nbpatient')
              .eq('nom', _selectedEtude)
              .single();

          if (etudeResponse != null && etudeResponse['nbpatient'] != null) {
            int currentNbPatient = etudeResponse['nbpatient'];
            await supabase.from('etude').update({'nbpatient': currentNbPatient + 1}).eq('nom', _selectedEtude);
            debugPrint("✅ Nombre de patients mis à jour : ${currentNbPatient + 1}");
          } else {
            debugPrint("⚠ Problème avec la récupération du nombre de patients.");
          }
        }

        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text("Patient ajouté avec succès !")),
        );

        Navigator.pushReplacement(currentContext, MaterialPageRoute(builder: (context) => const AccueilPage()));
      } catch (e) {
        debugPrint("❌ Erreur lors de l'ajout du patient : $e");
        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout du patient: ${e.toString()}")),
        );
      }
    }
  }
  /// **Widget pour sélectionner la date d'inclusion**
  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? "Sélectionner une date d'inclusion"
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              style: const TextStyle(fontSize: 18),
            ),
            const Icon(Icons.calendar_today, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7E7E),
        title: const Text(
          "Ajout d'un patient",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home, size: 30, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccueilPage()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Identifiant du patient (optionnel)"),
                onChanged: (value) {
                  setState(() {
                    _patientId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildDatePicker(context),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _addPatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text(
                  "Valider",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Dropdown pour sélectionner l'étude**
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Nom de l'étude",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
      items: _etudes.map((etude) {
        return DropdownMenuItem(value: etude, child: Text(etude));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEtude = value;
        });
      },
      validator: (value) => value == null ? "Veuillez sélectionner une étude valide" : null,
    );
  }
}
