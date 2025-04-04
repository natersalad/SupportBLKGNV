import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:supportblkgnv/services/mock_community_service.dart';

class EconomicImpactChart extends StatefulWidget {
  final String title;
  final String subtitle;
  final ChartType chartType;
  
  const EconomicImpactChart({
    Key? key,
    this.title = 'Economic Impact',
    this.subtitle = 'Community spending over time',
    this.chartType = ChartType.line,
  }) : super(key: key);

  @override
  State<EconomicImpactChart> createState() => _EconomicImpactChartState();
}

enum ChartType { line, bar, pie }

class _EconomicImpactChartState extends State<EconomicImpactChart> {
  final MockCommunityService _mockService = MockCommunityService();
  int _touchedIndex = -1;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: _buildChart(),
            ),
            if (widget.chartType == ChartType.pie) ...[
              const SizedBox(height: 16),
              _buildPieLegend(),
            ],
            const SizedBox(height: 16),
            _buildImpactSummary(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildChart() {
    switch (widget.chartType) {
      case ChartType.line:
        return _buildLineChart();
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.pie:
        return _buildPieChart();
    }
  }
  
  Widget _buildLineChart() {
    final impactReport = _mockService.getImpactReports().first;
    final spendingData = impactReport.monthlySpending;
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: true,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                final index = value.toInt();
                if (index >= 0 && index < months.length) {
                  return Text(months[index]);
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                final formatter = NumberFormat.compactCurrency(
                  decimalDigits: 0,
                  symbol: '\$',
                );
                return Text(formatter.format(value));
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: spendingData.length - 1.0,
        minY: 0,
        maxY: spendingData.reduce((max, value) => value > max ? value : max) * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              spendingData.length,
              (index) => FlSpot(index.toDouble(), spendingData[index]),
            ),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBarChart() {
    final impactReport = _mockService.getImpactReports().first;
    final spendingByCategory = impactReport.spendingByCategory;
    final categories = spendingByCategory.keys.toList();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: spendingByCategory.values.reduce((max, value) => value > max ? value : max) * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final category = categories[group.x.toInt()];
              final value = spendingByCategory[category];
              final formatter = NumberFormat.currency(symbol: '\$');
              return BarTooltipItem(
                '$category\n${formatter.format(value)}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < categories.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      categories[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 42,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                final formatter = NumberFormat.compactCurrency(
                  decimalDigits: 0,
                  symbol: '\$',
                );
                return Text(formatter.format(value));
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          categories.length,
          (index) {
            final category = categories[index];
            final value = spendingByCategory[category]!;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: Theme.of(context).colorScheme.primary,
                  width: 22,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: spendingByCategory.values.reduce((max, value) => value > max ? value : max) * 1.2,
                    color: const Color(0xFFE0E0E0),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPieChart() {
    final impactReport = _mockService.getImpactReports().first;
    final spendingByCategory = impactReport.spendingByCategory;
    final categories = spendingByCategory.keys.toList();
    final values = spendingByCategory.values.toList();
    
    // Color palette for the pie chart sections
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.red,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];
    
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }
              _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: List.generate(
          categories.length,
          (index) {
            final isTouched = index == _touchedIndex;
            final fontSize = isTouched ? 20.0 : 16.0;
            final radius = isTouched ? 110.0 : 100.0;
            
            return PieChartSectionData(
              color: colors[index % colors.length],
              value: values[index],
              title: '${(values[index] / impactReport.totalSpending * 100).toStringAsFixed(1)}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildPieLegend() {
    final impactReport = _mockService.getImpactReports().first;
    final spendingByCategory = impactReport.spendingByCategory;
    final categories = spendingByCategory.keys.toList();
    
    // Color palette for the pie chart sections
    final colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.amber,
      Colors.red,
      Colors.teal,
      Colors.orange,
      Colors.pink,
    ];
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(
        categories.length,
        (index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                color: colors[index % colors.length],
              ),
              const SizedBox(width: 4),
              Text(categories[index]),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildImpactSummary() {
    final impactReport = _mockService.getImpactReports().first;
    final formatter = NumberFormat.currency(symbol: '\$');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Text(
          'Summary',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildSummaryItem('Total Spending', formatter.format(impactReport.totalSpending)),
        _buildSummaryItem('Total Transactions', impactReport.totalTransactions.toString()),
        _buildSummaryItem('Average Transaction', formatter.format(impactReport.totalSpending / impactReport.totalTransactions)),
      ],
    );
  }
  
  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
} 