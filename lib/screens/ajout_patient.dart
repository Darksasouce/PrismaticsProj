import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
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
  String? _patientId;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchEtudes();
  }

  /// **🔹 Récupérer les études disponibles**
  Future<void> _fetchEtudes() async {
    try {
      final response = await supabase.from('etude').select('nom');
      if (response.isNotEmpty) {
        setState(() {
          _etudes = List<String>.from(response.map((e) => e['nom']));
        });
      }
    } catch (e) {
      debugPrint("❌ Erreur récupération études : $e");
    }
  }

  /// **🔹 Ouvre un DatePicker pour sélectionner la date d'inclusion**
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

  /// **🔹 Générer un identifiant patient unique si aucun n'est saisi**
  String _generateIdentifiant() {
    return "PAT-${Random().nextInt(9999999)}"; // Génère un identifiant de type PAT-XXXXXXX
  }

  /// **🔹 Ajouter un patient et mettre à jour le compteur**
  Future<void> _addPatient() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final currentContext = context;

    try {
      if (!_etudes.contains(_selectedEtude)) {
        throw Exception("L'étude sélectionnée n'est pas valide.");
      }

      // **Générer un identifiant unique si vide**
      String generatedIdentifiant = _patientId != null && _patientId!.isNotEmpty
          ? _patientId!
          : _generateIdentifiant();

      String inclusionDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now());

      debugPrint("📝 Tentative d'insertion...");
      await supabase.from('patients').insert({
        'etude': _selectedEtude,
        'inclusion_date': inclusionDate,
        'identifiant': generatedIdentifiant, // ✅ Ajout du champ identifiant
      });

      debugPrint("✅ Patient ajouté avec succès.");

      // **🔄 Mise à jour du compteur de patients**
      final etudeResponse = await supabase
          .from('etude')
          .select('nbpatient')
          .eq('nom', _selectedEtude)
          .maybeSingle();

      if (etudeResponse != null && etudeResponse['nbpatient'] != null) {
        int currentNbPatient = etudeResponse['nbpatient'];
        await supabase.from('etude').update({'nbpatient': currentNbPatient + 1}).eq('nom', _selectedEtude);
        debugPrint("✅ Nombre de patients mis à jour : ${currentNbPatient + 1}");
      } else {
        debugPrint("⚠ Problème récupération nbpatient.");
      }

      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(content: Text("Patient ajouté avec succès ! Identifiant : $generatedIdentifiant")),
      );

      Navigator.pushReplacement(currentContext, MaterialPageRoute(builder: (context) => const AccueilPage()));
    } catch (e) {
      debugPrint("❌ Erreur lors de l'ajout du patient : $e");
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Ajout d'un patient", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Identifiant du patient (optionnel)"),
                keyboardType: TextInputType.text,
                onChanged: (value) => _patientId = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Nom de l'étude",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                items: _etudes.map((etude) {
                  return DropdownMenuItem(value: etude, child: Text(etude));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEtude = value;
                  });
                },
                validator: (value) => value == null ? "Veuillez sélectionner une étude" : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
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
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _addPatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text("Valider", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
