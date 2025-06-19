import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/venta.dart';
import '../controller/ventas_controller.dart';

class DataInputView extends StatefulWidget {
  final List<Ciudad> ciudades;

  const DataInputView({super.key, required this.ciudades, required void Function() onDataChanged});

  @override
  State<DataInputView> createState() => _DataInputViewState();
}

class _DataInputViewState extends State<DataInputView> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreEmpleadoController = TextEditingController();
  final _ventasController = TextEditingController();
  
  String? _ciudadSeleccionada;
  String? _tiendaSeleccionada;
  String _inputType = 'empleado';
  
  final _nombreTiendaController = TextEditingController();
  final _nombreCiudadController = TextEditingController();
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nombreEmpleadoController.dispose();
    _ventasController.dispose();
    _nombreTiendaController.dispose();
    _nombreCiudadController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Tienda> _getTiendasPorCiudad(String ciudadNombre) {
    final ciudad = widget.ciudades.firstWhere((c) => c.nombre == ciudadNombre);
    return ciudad.tiendas;
  }

  void _agregarEmpleado() {
    if (_formKey.currentState!.validate() && 
        _ciudadSeleccionada != null && 
        _tiendaSeleccionada != null) {
      
      final ciudad = widget.ciudades.firstWhere((c) => c.nombre == _ciudadSeleccionada);
      final tienda = ciudad.tiendas.firstWhere((t) => t.nombre == _tiendaSeleccionada);
      
      final nuevoEmpleado = Empleado(
        nombre: _nombreEmpleadoController.text,
        ventas: double.parse(_ventasController.text),
      );
      
      tienda.empleados.add(nuevoEmpleado);
      
      _mostrarMensaje('Empleado agregado exitosamente');
      _limpiarFormulario();
      setState(() {});
    }
  }

  void _eliminarEmpleado(Ciudad ciudad, Tienda tienda, Empleado empleado) {
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
                  tienda.empleados.remove(empleado);
                });
                Navigator.of(context).pop();
                _mostrarMensaje('Empleado eliminado exitosamente', Colors.red);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarTienda(Ciudad ciudad, Tienda tienda) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar la tienda ${tienda.nombre}?\nSe eliminarán ${tienda.empleados.length} empleados y ventas por \$${tienda.calcularTotalTienda().toStringAsFixed(2)}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  ciudad.tiendas.remove(tienda);
                });
                Navigator.of(context).pop();
                _mostrarMensaje('Tienda eliminada exitosamente', Colors.red);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarCiudad(Ciudad ciudad) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de eliminar la ciudad ${ciudad.nombre}?\nSe eliminarán ${ciudad.tiendas.length} tiendas y ventas por \$${ciudad.calcularTotalCiudad().toStringAsFixed(2)}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.ciudades.remove(ciudad);
                });
                Navigator.of(context).pop();
                _mostrarMensaje('Ciudad eliminada exitosamente', Colors.red);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensaje(String mensaje, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color ?? Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _limpiarFormulario() {
    _nombreEmpleadoController.clear();
    _ventasController.clear();
    _nombreTiendaController.clear();
    _nombreCiudadController.clear();
    setState(() {
      _ciudadSeleccionada = null;
      _tiendaSeleccionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestionar Datos de Ventas"),
        backgroundColor: Colors.green[800],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add), text: "Agregar"),
            Tab(icon: Icon(Icons.list), text: "Gestionar"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabAgregar(),
          _buildTabGestionar(),
        ],
      ),
    );
  }

  Widget _buildTabAgregar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Selector de tipo de input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "¿Qué deseas agregar?",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile<String>(
                      title: const Text('Empleado'),
                      value: 'empleado',
                      groupValue: _inputType,
                      onChanged: (value) {
                        setState(() {
                          _inputType = value!;
                          _limpiarFormulario();
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Tienda'),
                      value: 'tienda',
                      groupValue: _inputType,
                      onChanged: (value) {
                        setState(() {
                          _inputType = value!;
                          _limpiarFormulario();
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Ciudad'),
                      value: 'ciudad',
                      groupValue: _inputType,
                      onChanged: (value) {
                        setState(() {
                          _inputType = value!;
                          _limpiarFormulario();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Formularios dinámicos según el tipo
            Expanded(
              child: SingleChildScrollView(
                child: _buildFormulario(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabGestionar() {
    final controller = VentasController(widget.ciudades);
    final totalGeneral = controller.calcularTotalGeneral();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Resumen actual
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    "Total General: \$${totalGeneral.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: totalGeneral > 100000 ? Colors.green : Colors.blue,
                    ),
                  ),
                  if (totalGeneral > 100000)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.volume_up, color: Colors.green),
                        SizedBox(width: 8),
                        Text("¡Objetivo superado!", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de ciudades para gestionar
          Expanded(
            child: ListView.builder(
              itemCount: widget.ciudades.length,
              itemBuilder: (context, ciudadIndex) {
                final ciudad = widget.ciudades[ciudadIndex];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ExpansionTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(ciudad.nombre),
                    subtitle: Text("Total: \$${ciudad.calcularTotalCiudad().toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarCiudad(ciudad),
                    ),
                    children: ciudad.tiendas.map((tienda) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: ExpansionTile(
                          leading: const Icon(Icons.store),
                          title: Text(tienda.nombre),
                          subtitle: Text("Total: \$${tienda.calcularTotalTienda().toStringAsFixed(2)}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _eliminarTienda(ciudad, tienda),
                          ),
                          children: tienda.empleados.map((empleado) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                child: Text(empleado.nombre[0]),
                              ),
                              title: Text(empleado.nombre),
                              subtitle: Text("Ventas: \$${empleado.ventas.toStringAsFixed(2)}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarEmpleado(ciudad, tienda, empleado),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulario() {
    switch (_inputType) {
      case 'empleado':
        return _buildFormularioEmpleado();
      case 'tienda':
        return _buildFormularioTienda();
      case 'ciudad':
        return _buildFormularioCiudad();
      default:
        return Container();
    }
  }

  Widget _buildFormularioEmpleado() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agregar Empleado",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Selector de ciudad
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                border: OutlineInputBorder(),
              ),
              value: _ciudadSeleccionada,
              items: widget.ciudades.map((ciudad) {
                return DropdownMenuItem(
                  value: ciudad.nombre,
                  child: Text(ciudad.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _ciudadSeleccionada = value;
                  _tiendaSeleccionada = null;
                });
              },
              validator: (value) => value == null ? 'Selecciona una ciudad' : null,
            ),
            
            const SizedBox(height: 16),
            
            // Selector de tienda
            if (_ciudadSeleccionada != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tienda',
                  border: OutlineInputBorder(),
                ),
                value: _tiendaSeleccionada,
                items: _getTiendasPorCiudad(_ciudadSeleccionada!).map((tienda) {
                  return DropdownMenuItem(
                    value: tienda.nombre,
                    child: Text(tienda.nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tiendaSeleccionada = value;
                  });
                },
                validator: (value) => value == null ? 'Selecciona una tienda' : null,
              ),
            
            const SizedBox(height: 16),
            
            // Nombre del empleado
            TextFormField(
              controller: _nombreEmpleadoController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Empleado',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el nombre del empleado';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Ventas
            TextFormField(
              controller: _ventasController,
              decoration: const InputDecoration(
                labelText: 'Ventas (\$)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el monto de ventas';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingresa un número válido';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Botón agregar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _agregarEmpleado,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Empleado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormularioTienda() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agregar Tienda",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ciudad',
                border: OutlineInputBorder(),
              ),
              value: _ciudadSeleccionada,
              items: widget.ciudades.map((ciudad) {
                return DropdownMenuItem(
                  value: ciudad.nombre,
                  child: Text(ciudad.nombre),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _ciudadSeleccionada = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _nombreTiendaController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Tienda',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _agregarTienda,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Tienda'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormularioCiudad() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Agregar Ciudad",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _nombreCiudadController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la Ciudad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _agregarCiudad,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Ciudad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _agregarTienda() {
    if (_ciudadSeleccionada != null && _nombreTiendaController.text.isNotEmpty) {
      final ciudad = widget.ciudades.firstWhere((c) => c.nombre == _ciudadSeleccionada);
      final existeTienda = ciudad.tiendas.any((t) => t.nombre == _nombreTiendaController.text);
      if (existeTienda) {
        _mostrarMensaje('La tienda ya existe en esta ciudad', Colors.orange);
        return;
      }
      final nuevaTienda = Tienda(nombre: _nombreTiendaController.text, empleados: []);
      setState(() {
        ciudad.tiendas.add(nuevaTienda);
      });
      _mostrarMensaje('Tienda agregada exitosamente');
      _limpiarFormulario();
    } else {
      _mostrarMensaje('Completa todos los campos', Colors.orange);
    }
  }

  void _agregarCiudad() {
    if (_nombreCiudadController.text.isNotEmpty) {
      final existeCiudad = widget.ciudades.any((c) => c.nombre == _nombreCiudadController.text);
      if (existeCiudad) {
        _mostrarMensaje('La ciudad ya existe', Colors.orange);
        return;
      }
      final nuevaCiudad = Ciudad(nombre: _nombreCiudadController.text, tiendas: []);
      setState(() {
        widget.ciudades.add(nuevaCiudad);
      });
      _mostrarMensaje('Ciudad agregada exitosamente');
      _limpiarFormulario();
    } else {
      _mostrarMensaje('Ingresa el nombre de la ciudad', Colors.orange);
    }
  }
}
