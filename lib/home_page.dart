import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class HomePage extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: CustomScrollView(
          slivers: [
            // First Large Box (Line Chart)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 300,
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LineChart(
                        LineChartData(
                          backgroundColor: Colors.grey[800],
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text('Week ${value.toInt() + 1}', style: TextStyle(color: Colors.white));
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white)),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 50), // Week 1
                                FlSpot(1, 55), // Week 2
                                FlSpot(2, 60), // Week 3
                                FlSpot(3, 63), // Week 4
                                FlSpot(4, 67), // Week 5
                                FlSpot(5, 72), // Week 6
                              ],
                              isCurved: true,
                              color: Colors.blue,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(show: false),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Two Smaller Boxes (Side by Side)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    // Left Box
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          color: Colors.grey[800],
                          child: Center(
                            child: Text(
                              'Box 1 Data',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Space between the boxes
                    // Right Box
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          color: Colors.grey[800],
                          child: Center(
                            child: Text(
                              'Box 2 Data',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Second Large Box
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 200,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}