import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends ConsumerState<UserScreen> {
  int selectedDataSetIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.person, size: 70),
            Text('Gavin', style: Theme.of(context).textTheme.headlineSmall),
            const Text('Lvl. 2'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Column(
                children: [
                  LinearProgressIndicator(value: .25),
                  const SizedBox(height: 4),
                  const Text('Next Level: 29 EXP'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: RadarChart(
                RadarChartData(
                  dataSets: showingDataSets(),
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.grey),
                  titlePositionPercentageOffset: 0.1,
                  titleTextStyle: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                  getTitle: (index, angle) {
                    switch (index) {
                      case 0:
                        return RadarChartTitle(
                          text: 'Physical',
                          angle: 0,
                        );
                      case 1:
                        return RadarChartTitle(
                          text: 'Mental',
                          angle: 0,
                        );
                      case 2:
                        return RadarChartTitle(
                          text: 'Spiritual',
                          angle: 0,
                        );
                      default:
                        return const RadarChartTitle(text: '');
                    }
                  },
                  tickCount: 1,
                  ticksTextStyle: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 10,
                  ),
                  tickBorderData: const BorderSide(color: Colors.transparent),
                  gridBorderData: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
            ),
            const Text('Your Well-Being'),
          ],
        ),
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected =
        selectedDataSetIndex == -1 || index == selectedDataSetIndex;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withValues(alpha: 0.2)
            : rawDataSet.color.withValues(alpha: 0.05),
        borderColor: isSelected
            ? rawDataSet.color
            : rawDataSet.color.withValues(alpha: 0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries: rawDataSet.values
            .map((e) => RadarEntry(value: e))
            .toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'Stats',
        color: Colors.greenAccent,
        values: [60, 70, 50],
      ),
    ];
  }
}

class RawDataSet {
  RawDataSet({required this.title, required this.color, required this.values});

  final String title;
  final Color color;
  final List<double> values;
}
