// precio_distancia_state.dart
part of 'precio_distancia_bloc.dart';

class PrecioDistanciaState extends Equatable {
  final double precioActual;
  final double distanciaRecorrida;
  final LatLng? ultimaUbicacion;

  const PrecioDistanciaState({
    this.precioActual = 0.0,
    this.distanciaRecorrida = 0.0,
    this.ultimaUbicacion,
  });

  PrecioDistanciaState copyWith({
    double? precioActual,
    double? distanciaRecorrida,
    LatLng? ultimaUbicacion,
  }) {
    return PrecioDistanciaState(
      precioActual: precioActual ?? this.precioActual,
      distanciaRecorrida: distanciaRecorrida ?? this.distanciaRecorrida,
      ultimaUbicacion: ultimaUbicacion ?? this.ultimaUbicacion,
    );
  }

  @override
  List<Object?> get props => [precioActual, distanciaRecorrida, ultimaUbicacion];
}


