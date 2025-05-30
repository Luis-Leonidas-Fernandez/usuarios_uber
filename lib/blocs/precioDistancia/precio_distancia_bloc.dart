import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/models/tarifa.dart';

part 'precio_distancia_event.dart';
part 'precio_distancia_state.dart';

class PrecioDistanciaBloc extends Bloc<PrecioDistanciaEvent, PrecioDistanciaState> {
  final List<Tarifa> tarifas;
  final Distance _distance = const Distance();

  PrecioDistanciaBloc({required this.tarifas}) : super(const PrecioDistanciaState()) {
    on<ActualizarUbicacionEvent>(_onActualizarUbicacion);
    on<ResetearPrecioDistanciaEvent>(_onReset);
  }

  void _onActualizarUbicacion(ActualizarUbicacionEvent event, Emitter<PrecioDistanciaState> emit) {
    if (state.ultimaUbicacion == null) {
      emit(state.copyWith(ultimaUbicacion: event.ubicacion));
      return;
    }

    final double metros = _distance.as(
      LengthUnit.Meter,
      state.ultimaUbicacion!,
      event.ubicacion,
    );

    final double nuevaDistancia = state.distanciaRecorrida + metros;
    final double nuevoPrecio = _calcularPrecio(nuevaDistancia);

    emit(state.copyWith(
      ultimaUbicacion: event.ubicacion,
      distanciaRecorrida: nuevaDistancia,
      precioActual: nuevoPrecio,
    ));
  }

  void _onReset(ResetearPrecioDistanciaEvent event, Emitter<PrecioDistanciaState> emit) {
    emit(const PrecioDistanciaState());
  }

  double _calcularPrecio(double distanciaMetros) {
  final km = distanciaMetros / 1000.0;

  // Buscar la tarifa más cercana en base a 'puntos'
  Tarifa? tarifaCercana;
  double diferenciaMinima = double.infinity;

  for (final tarifa in tarifas) {
    final diferencia = (tarifa.puntos - km).abs();

    if (diferencia < diferenciaMinima) {
      diferenciaMinima = diferencia;
      tarifaCercana = tarifa;
    }
  }

  return tarifaCercana?.precio.toDouble() ?? 0.0;
}

}

