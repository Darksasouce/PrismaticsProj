import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class PredipainChart extends StatefulWidget {
  const PredipainChart({super.key});

  @override
  _PredipainChartState createState() => _PredipainChartState();
}

class _PredipainChartState extends State<PredipainChart> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<FlSpot> realInclusions = [];
  Map<double, String> dateLabelsMap = {}; // Stocke les correspondances (x, date)
  bool isLoading = true;
  bool hasData = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  /// **🔹 Récupère les données et les formate**
  Future<void> _fetchChartData() async {
    try {
      debugPrint("🔍 Chargement des données...");

      final responsePatients = await supabase
          .from('patients')
          .select('inclusion_date')
          .ilike('etude', 'predipain') // 🔹 Insensible à la casse
          .order('inclusion_date', ascending: true);

      if (responsePatients.isEmpty) {
        debugPrint("❌ Aucun patient trouvé !");
        setState(() {
          isLoading = false;
          hasData = false;
          errorMessage = "Aucune donnée disponible pour cette étude.";
        });
        return;
      }

      List<DateTime> inclusionDates = responsePatients
          .map((entry) => entry['inclusion_date'] != null
          ? DateTime.parse(entry['inclusion_date'].toString())
          : null)
          .where((date) => date != null)
          .cast<DateTime>()
          .toList();

      List<FlSpot> realData = [];
      Map<double, String> labelsMap = {};
      int patientCount = 0;

      for (var date in inclusionDates) {
        patientCount++;
        double xValue = date.difference(inclusionDates.first).inDays.toDouble();
        realData.add(FlSpot(xValue, patientCount.toDouble()));

        labelsMap[xValue] = DateFormat('d MMM yyyy').format(date); // 🔹 Date sous son point
      }

      setState(() {
        realInclusions = realData;
        dateLabelsMap = labelsMap;
        isLoading = false;
        hasData = true;
      });

      debugPrint("✅ Graphique mis à jour avec ${realInclusions.length} points !");
    } catch (e) {
      debugPrint("❌ Erreur lors du chargement des données : $e");
      setState(() {
        isLoading = false;
        hasData = false;
        errorMessage = "Erreur de chargement : ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height; // 🔹 Récupérer la hauteur de l’écran
    double graphHeight = screenHeight * 0.4; // 🔹 Adapter la hauteur du graphique pour mobile

    return SingleChildScrollView( // 🔹 Ajoute un scroll si nécessaire
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasData
            ? Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: graphHeight, // 🔹 Utilisation de la hauteur dynamique
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: const Text(
                        "Nombre de patients",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1, // Graduation de 1 en 1
                        getTitlesWidget: (value, meta) {
                          return value >= 1
                              ? Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text(
                        "Date d'inclusion",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (dateLabelsMap.containsKey(value)) {
                            return Transform.rotate(
                              angle: -0.5, // 🔹 Inclinaison des dates pour éviter chevauchement
                              child: Text(
                                dateLabelsMap[value]!,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // 🔹 Suppression des graduations du haut
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // 🔹 Suppression des graduations de droite
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    verticalInterval: 1, // 🔹 Espacement des dates
                    horizontalInterval: 1, // 🔹 Espacement des patients (1 par ligne)
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: realInclusions,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "🔵 Inclusions réelles",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        )
            : Center(
          child: Text(
            errorMessage,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
