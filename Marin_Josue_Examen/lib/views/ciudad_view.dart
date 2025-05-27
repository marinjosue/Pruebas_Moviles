import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/venta.dart';
import 'tienda_view.dart';

class CiudadView extends StatelessWidget {
  final List<Ciudad> ciudades;

  const CiudadView({super.key, required this.ciudades});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ventas por Ciudad"),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          // Logo local
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              'assets/images/logo.png',
              height: 80,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.store, size: 80),
            ),
          ),
          
          // Gráfico de barras
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                barGroups: ciudades.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.calcularTotalCiudad(),
                        color: Colors.blue[700],
                        width: 20,
                      )
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < ciudades.length) {
                          return Text(ciudades[value.toInt()].nombre);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Lista de ciudades
          Expanded(
            child: ListView.builder(
              itemCount: ciudades.length,
              itemBuilder: (context, index) {
                final ciudad = ciudades[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(ciudad.nombre),
                    subtitle: Text("Total: \$${ciudad.calcularTotalCiudad().toStringAsFixed(2)}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TiendaView(ciudad: ciudad),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
