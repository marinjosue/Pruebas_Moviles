import 'package:flutter/material.dart';
import '../model/venta.dart';
import '../controller/ventas_controller.dart';
import 'ciudad_view.dart';
import 'data_input_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late VentasController controller;
  late List<Ciudad> ciudades;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Datos de ejemplo
    ciudades = [
      Ciudad(
        nombre: "Quito",
        tiendas: [
          Tienda(
            nombre: "El Mandilón Norte",
            empleados: [
              Empleado(nombre: "Juan Pérez", ventas: 8500.0),
              Empleado(nombre: "María García", ventas: 7200.0),
              Empleado(nombre: "Carlos López", ventas: 9100.0),
            ],
          ),
          Tienda(
            nombre: "El Mandilón Sur",
            empleados: [
              Empleado(nombre: "Ana Martínez", ventas: 6800.0),
              Empleado(nombre: "Luis Rodríguez", ventas: 7500.0),
            ],
          ),
        ],
      ),
      Ciudad(
        nombre: "Guayaquil",
        tiendas: [
          Tienda(
            nombre: "El Mandilón Centro",
            empleados: [
              Empleado(nombre: "Sofia Herrera", ventas: 9200.0),
              Empleado(nombre: "Diego Torres", ventas: 8000.0),
              Empleado(nombre: "Carmen Vásquez", ventas: 7800.0),
            ],
          ),
        ],
      ),
      Ciudad(
        nombre: "Cuenca",
        tiendas: [
          Tienda(
            nombre: "El Mandilón Plaza",
            empleados: [
              Empleado(nombre: "Roberto Morales", ventas: 6500.0),
              Empleado(nombre: "Lucia Fernández", ventas: 7000.0),
            ],
          ),
        ],
      ),
    ];
    
    controller = VentasController(ciudades);
  }

  void _refreshData() {
    setState(() {
      controller = VentasController(ciudades);
      controller.notificarCambio(); // Trigger sound check
    });
  }

  Future<void> _navegarAInputDatos() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataInputView(
          ciudades: ciudades,
          onDataChanged: _refreshData, // Pass the callback
        ),
      ),
    );
    // Ensure refresh when returning
    if (result != null || mounted) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalGeneral = controller.calcularTotalGeneral();
    final totalEmpleados = controller.getTotalEmpleados();
    final totalTiendas = controller.getTotalTiendas();
    final mejorEmpleado = controller.getMejorEmpleado();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("El Mandilón - Ventas"),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navegarAInputDatos,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo principal
            Container(
              padding: const EdgeInsets.all(20),
              child: Image.asset(
                'assets/images/logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.store, size: 120, color: Colors.blue),
              ),
            ),
            
            // Resumen de ventas actualizado
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Resumen General",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Total de Ciudades: ${ciudades.length}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Total de Tiendas: $totalTiendas",
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      "Total de Empleados: $totalEmpleados",
                      style: const TextStyle(fontSize: 18),
                    ),
                    if (mejorEmpleado != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Mejor Empleado: ${mejorEmpleado.nombre} (\$${mejorEmpleado.ventas.toStringAsFixed(2)})",
                          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      "Total General: \$${totalGeneral.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: totalGeneral > 100000 ? Colors.green : Colors.blue,
                      ),
                    ),
                    if (totalGeneral > 100000)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.volume_up, color: Colors.green),
                            const SizedBox(width: 8),
                            const Text("¡Objetivo superado!", style: TextStyle(color: Colors.green)),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                controller.reproducirSonidoPrueba();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(60, 30),
                              ),
                              child: const Icon(Icons.play_arrow, size: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botones de acción actualizados
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _navegarAInputDatos,
                  icon: const Icon(Icons.add),
                  label: const Text("Ingresar Datos"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CiudadView(ciudades: ciudades),
                      ),
                    ).then((_) => _refreshData()); // Actualizar al regresar
                  },
                  icon: const Icon(Icons.analytics),
                  label: const Text("Ver Análisis"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            
            // Indicador de última actualización
            const SizedBox(height: 10),
            Text(
              "Última actualización: ${DateTime.now().toString().split('.')[0]}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarAInputDatos,
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
      ),
    );
  }
}
