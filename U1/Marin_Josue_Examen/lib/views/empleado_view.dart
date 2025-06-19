import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/venta.dart';

class EmpleadoView extends StatefulWidget {
  final Tienda tienda;

  const EmpleadoView({super.key, required this.tienda});

  @override
  State<EmpleadoView> createState() => _EmpleadoViewState();
}

class _EmpleadoViewState extends State<EmpleadoView> {
  void _eliminarEmpleado(Empleado empleado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar a ${empleado.nombre}?\nSus ventas de \$${empleado.ventas.toStringAsFixed(2)} se eliminarán del total.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.tienda.empleados.remove(empleado);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Empleado eliminado exitosamente'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Empleados - ${widget.tienda.nombre}"),
        backgroundColor: Colors.purple[800],
      ),
      body: Column(
        children: [
          // Imagen remota de empleados
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.network(
              'https://via.placeholder.com/300x150/9C27B0/FFFFFF?text=Rendimiento+Empleados',
              height: 100,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.people, size: 80),
            ),
          ),
          
          // Gráfico de líneas
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.tienda.empleados.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.ventas);
                    }).toList(),
                    color: Colors.purple,
                    barWidth: 3,
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < widget.tienda.empleados.length) {
                          return Text(widget.tienda.empleados[value.toInt()].nombre.split(' ')[0]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: widget.tienda.empleados.length,
              itemBuilder: (context, index) {
                final empleado = widget.tienda.empleados[index];
                return Dismissible(
                  key: Key('${empleado.nombre}_$index'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmar Eliminación'),
                          content: Text('¿Eliminar a ${empleado.nombre}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      widget.tienda.empleados.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${empleado.nombre} eliminado'),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'Deshacer',
                          onPressed: () {
                            setState(() {
                              widget.tienda.empleados.insert(index, empleado);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.purple[100],
                        child: Text(empleado.nombre[0]),
                      ),
                      title: Text(empleado.nombre),
                      subtitle: Text("Ventas: \$${empleado.ventas.toStringAsFixed(2)}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            empleado.ventas > 5000 ? Icons.star : Icons.person,
                            color: empleado.ventas > 5000 ? Colors.amber : Colors.grey,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarEmpleado(empleado),
                          ),
                        ],
                      ),
                    ),
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

