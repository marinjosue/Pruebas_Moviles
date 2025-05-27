class Empleado {
  final String nombre;
  final double ventas;

  Empleado({required this.nombre, required this.ventas});
}

class Tienda {
  final String nombre;
  final List<Empleado> empleados;

  Tienda({required this.nombre, required this.empleados});

  double calcularTotalTienda() =>
      empleados.fold(0, (suma, e) => suma + e.ventas);
}

class Ciudad {
  final String nombre;
  final List<Tienda> tiendas;

  Ciudad({required this.nombre, required this.tiendas});

  double calcularTotalCiudad() =>
      tiendas.fold(0, (suma, t) => suma + t.calcularTotalTienda());
}
