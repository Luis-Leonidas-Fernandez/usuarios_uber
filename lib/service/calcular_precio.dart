import '../models/tarifa.dart';

class CalcularPrecioService {
  
  int calcularPrecio({
    required double distanciaKm,
    required List<Tarifa> tarifas,
  }) {
    final tarifa = tarifas.firstWhere(
      (t) => t.puntos >= distanciaKm,
      orElse: () => tarifas.last,
    );
    return tarifa.precio;
  }
}
