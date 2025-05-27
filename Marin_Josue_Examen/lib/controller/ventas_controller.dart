import '../model/venta.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VentasController {
  final List<Ciudad> ciudades;
  final AudioPlayer _player = AudioPlayer();
  static bool _sonidoReproducido = false;
  static double _ultimoTotal = 0; // Recordar último total para detectar cambios

  VentasController(this.ciudades);

  double calcularTotalGeneral() {
    double total = 0;
    for (var ciudad in ciudades) {
      total += ciudad.calcularTotalCiudad();
    }
    
    // Verificar si el total cambió significativamente
    if ((total - _ultimoTotal).abs() > 0.01) {
      _sonidoReproducido = false; // Reset cuando hay cambios
      _ultimoTotal = total;
    }
    
    if (total > 100000 && !_sonidoReproducido) {  
      _reproducirSonidoObjetivo();
      _sonidoReproducido = true;
    } else if (total <= 100000) {
      _sonidoReproducido = false;
    }
    return total;
  }

  // Método para notificar cambios en los datos
  void notificarCambio() {
    _sonidoReproducido = false;
    calcularTotalGeneral(); // Recalcular y posiblemente reproducir sonido
  }

  // Reset para permitir nuevo sonido cuando cambian los datos
  static void resetSonido() {
    _sonidoReproducido = false;
  }

  Future<void> _reproducirSonidoObjetivo() async {
    try {
      await _player.play(AssetSource('audio/notificaciones.mp3'));
      debugPrint('Sonido de notificación reproducido - Objetivo superado!');
    } catch (e) {
      debugPrint('Error al reproducir sonido: $e');
      // Fallback: usar sonido del sistema
      _player.play(AssetSource('audio/success.wav'));
    }
  }

  // Método para forzar reproducción de sonido (útil para testing)
  void reproducirSonidoPrueba() async {
    await _reproducirSonidoObjetivo();
  }

  // Método para verificar si se supera el objetivo
  bool objetivoSuperado() {
    return calcularTotalGeneral() > 100000;
  }

  // Estadísticas adicionales
  int getTotalEmpleados() {
    return ciudades.fold(0, (sum, ciudad) => 
      sum + ciudad.tiendas.fold(0, (sum2, tienda) => sum2 + tienda.empleados.length));
  }

  int getTotalTiendas() {
    return ciudades.fold(0, (sum, ciudad) => sum + ciudad.tiendas.length);
  }

  Empleado? getMejorEmpleado() {
    Empleado? mejor;
    double maxVentas = 0;
    
    for (var ciudad in ciudades) {
      for (var tienda in ciudad.tiendas) {
        for (var empleado in tienda.empleados) {
          if (empleado.ventas > maxVentas) {
            maxVentas = empleado.ventas;
            mejor = empleado;
          }
        }
      }
    }
    
    return mejor;
  }
}
