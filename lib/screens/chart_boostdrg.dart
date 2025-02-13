import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class BoostDRGChart extends StatefulWidget {
  const BoostDRGChart({super.key});

  @override
  _BoostDRGChartState createState() => _BoostDRGChartState();
}

class _BoostDRGChartState extends State<BoostDRGChart> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<FlSpot> realInclusions = [];
  Map<double, String> dateLabelsMap = {};
  bool isLoading = true;
  bool hasData = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    try {
      debugPrint("🔍 Chargement des données...");

      final responsePatients = await supabase
          .from('patients')
          .select('inclusion_date')
          .ilike('etude', '%boostdrg%') // 🔹 Insensible à la casse et tolère variantes d'écriture
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

        labelsMap[xValue] = DateFormat('d MMM yyyy').format(date);
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
    double graphHeight = screenHeight * 0.4; // 🔹 Adapter la hauteur du graphique

    return isLoading
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
                    interval: 1,
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
                          angle: -0.5,
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
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                verticalInterval: 1,
                horizontalInterval: 1,
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.grey),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: realInclusions,
                  isCurved: true,
                  color: Colors.orange,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "🟠 Inclusions réelles",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    )
        : Center(
      child: Text(
        errorMessage,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
