import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/venta.dart';
import 'empleado_view.dart';

class TiendaView extends StatelessWidget {
  final Ciudad ciudad;

  const TiendaView({super.key, required this.ciudad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiendas - ${ciudad.nombre}"),
        backgroundColor: Colors.green[800],
      ),
      body: Column(
        children: [
          // Imagen remota de estadísticas
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.network(
              'https://via.placeholder.com/300x150/4CAF50/FFFFFF?text=Estadisticas+Tiendas',
              height: 100,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.bar_chart, size: 80),
            ),
          ),
          
          // Gráfico circular
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: PieChart(
              PieChartData(
                sections: ciudad.tiendas.map((tienda) {
                  return PieChartSectionData(
                    value: tienda.calcularTotalTienda(),
                    title: tienda.nombre,
                    color: Colors.primaries[ciudad.tiendas.indexOf(tienda) % Colors.primaries.length],
                    radius: 60,
                  );
                }).toList(),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: ciudad.tiendas.length,
              itemBuilder: (context, index) {
                final tienda = ciudad.tiendas[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.store),
                    title: Text(tienda.nombre),
                    subtitle: Text("Total: \$${tienda.calcularTotalTienda().toStringAsFixed(2)}"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmpleadoView(tienda: tienda),
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
