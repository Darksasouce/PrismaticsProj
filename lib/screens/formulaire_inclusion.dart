import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  _FormulairePageState createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  bool? _chronicPain, _fbss, _priorTreatment, _scsTrialEligible, _consent;
  int? _vasScore, _age;
  DateTime? _selectedDate;
  String inclusionResult = "Aucune étude";

  /// **🔹 Sélection de la date d'inclusion**
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

  /// **🔹 Générer un ID patient unique si vide**
  int _generatePatientId() {
    return Random().nextInt(900000) + 100000; // 6 chiffres
  }

  /// **🔹 Générer un identifiant patient unique**
  String _generateIdentifiant() {
    return "PAT-${Random().nextInt(9999999)}";
  }

  /// **🔹 Confirmation avant soumission**
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirmer la validation"),
          content: const Text("Êtes-vous sûr de vouloir soumettre ce formulaire ?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Confirmer"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _validateAndSubmit();
              },
            ),
          ],
        );
      },
    );
  }

  /// **🔹 Déterminer l'étude et insérer dans `patients`**
  Future<void> _validateAndSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_chronicPain == true && _age != null && _age! >= 18) {
      if (_fbss == true && _priorTreatment == true && _vasScore != null && _vasScore! >= 50 && _scsTrialEligible == true) {
        inclusionResult = "PREDIBACK";
      } else if (_vasScore != null && _vasScore! >= 2 && _consent == true) {
        inclusionResult = "PREDIPAIN";
      }
    }

    if (inclusionResult == "Aucune étude") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le patient ne remplit pas les critères d'aucune étude.")),
      );
      return;
    }

    await _addPatientToDatabase(inclusionResult);
  }

  /// **🔹 Ajouter patient à la BDD**
  Future<void> _addPatientToDatabase(String study) async {
    try {
      int patientId = _generatePatientId();
      String identifiant = _generateIdentifiant();
      String inclusionDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : DateFormat('yyyy-MM-dd').format(DateTime.now());

      await supabase.from('patients').insert({
        'id': patientId,
        'etude': study,
        'inclusion_date': inclusionDate,
        'identifiant': identifiant,
      });

      debugPrint("✅ Patient ajouté : ID $patientId, Identifiant $identifiant, Étude : $study");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient ajouté avec succès à l'étude $study")),
      );
    } catch (e) {
      debugPrint("❌ Erreur ajout patient : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'ajout du patient : ${e.toString()}")),
      );
    }
  }

  /// **🔹 Question Oui / Non**
  Widget _buildYesNoQuestion(String question, bool? currentValue, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => onChanged(true)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentValue == true ? Colors.green : Colors.grey.shade300,
                ),
                child: const Text("Oui", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => onChanged(false)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentValue == false ? Colors.red : Colors.grey.shade300,
                ),
                child: const Text("Non", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  /// **🔹 Interface utilisateur**
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulaire d'inclusion"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildYesNoQuestion("Le patient a-t-il des douleurs chroniques depuis plus de 3 mois ?", _chronicPain, (value) {
                setState(() => _chronicPain = value);
              }),
              _buildYesNoQuestion("Le patient a-t-il subi une chirurgie du dos avec douleur persistante (FBSS) ?", _fbss, (value) {
                setState(() => _fbss = value);
              }),
              _buildYesNoQuestion("Le patient a-t-il reçu des traitements (médicaments, chirurgie, etc.) sans succès ?", _priorTreatment, (value) {
                setState(() => _priorTreatment = value);
              }),
              _buildYesNoQuestion("Le patient peut-il bénéficier d’un essai de stimulation médullaire (SCS) ?", _scsTrialEligible, (value) {
                setState(() => _scsTrialEligible = value);
              }),
              _buildYesNoQuestion("Le patient a-t-il donné son consentement pour l'étude ?", _consent, (value) {
                setState(() => _consent = value);
              }),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Score de douleur (VAS)"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _vasScore = int.tryParse(value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "Âge du patient"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.tryParse(value!),
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
                  child: Text(
                    _selectedDate == null ? "Sélectionner une date d'inclusion" : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  child: const Text("Valider", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
