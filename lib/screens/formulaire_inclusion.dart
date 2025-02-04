import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  _FormulairePageState createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  bool? _chronicPain;
  bool? _fbss;
  bool? _priorTreatment;
  bool? _scsTrialEligible;
  bool? _consent;
  int? _vasScore;
  int? _age;
  String inclusionResult = "Aucune étude";

  /// **🔹 Déterminer l'étude et mettre à jour la base de données**
  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // **Déterminer l'étude selon les critères**
      if (_chronicPain == true && _age != null && _age! >= 18) {
        if (_fbss == true && _priorTreatment == true && _vasScore != null && _vasScore! >= 50 && _scsTrialEligible == true) {
          inclusionResult = "Étude sur Prediback";
        } else if (_vasScore != null && _vasScore! >= 2 && _consent == true) {
          inclusionResult = "Étude sur Predipain";
        }
      }

      // **Mettre à jour uniquement le nombre de patients dans l'étude**
      await _incrementNbPatient(inclusionResult);
    }
  }

  /// **🔹 Mise à jour du `nbpatient` dans la table `etude`**
  Future<void> _incrementNbPatient(String study) async {
    if (study == "Aucune étude") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le patient ne remplit pas les critères d'aucune étude.")),
      );
      return;
    }

    try {
      debugPrint("🔍 Mise à jour du nbpatient pour : $study");

      final response = await supabase
          .from('etude')
          .select('nbpatient')
          .eq('titre_complet', study)
          .maybeSingle();

      if (response == null || !response.containsKey('nbpatient')) {
        throw Exception("Aucune donnée trouvée pour l'étude : $study");
      }

      int currentNbPatient = response['nbpatient'] ?? 0;
      debugPrint("🔹 Nombre actuel de patients : $currentNbPatient");

      final updateResponse = await supabase
          .from('etude')
          .update({'nbpatient': currentNbPatient + 1})
          .eq('titre_complet', study)
          .select();

      debugPrint("✅ Réponse après update : $updateResponse");

      if (updateResponse.isEmpty) {
        throw Exception("La mise à jour a échoué. Vérifiez les conditions de la requête.");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le patient a été ajouté à l'étude : $study")),
      );
    } catch (e) {
      debugPrint("❌ Erreur lors de la mise à jour du nombre de patients : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour du nombre de patients : ${e.toString()}")),
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
                onPressed: () {
                  setState(() => onChanged(true));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: currentValue == true ? Colors.green : Colors.grey.shade300,
                ),
                child: const Text("Oui", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() => onChanged(false));
                },
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

  /// **🔹 Construction de l'interface**
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
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _validateAndSubmit,
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
