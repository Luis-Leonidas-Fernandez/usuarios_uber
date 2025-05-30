
import 'package:usuario_inri/models/address.dart';

extension OrderUserComparison on OrderUser {
  bool isDifferentFrom(OrderUser? other) {
    if (other == null) return true;

    return id != other.id ||
           idDriver != other.idDriver ||
           order != other.order ||
           horaEsperaInicio != other.horaEsperaInicio ||
           horaEsperaFin != other.horaEsperaFin ||
           precio != other.precio ||
           distanciaKm != other.distanciaKm ||
           ok != other.ok;
  }
}
