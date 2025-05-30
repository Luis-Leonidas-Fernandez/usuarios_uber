
import 'package:usuario_inri/models/address.dart';

extension OrderUserExtension on OrderUser {
  bool get isWaitingDriver {
    if (id == null || id!.isEmpty) return false;
    if (order == null || order == '' || order == 'libre' || order == 'en-camino' || order == 'llego-conductor') return true;
    return false;
  }

  bool get isTripActive {
    return order == 'en-camino' || order == 'llego-conductor';
  }

  bool get isTripFinished {
    return order == 'finalizado';
  }
}
