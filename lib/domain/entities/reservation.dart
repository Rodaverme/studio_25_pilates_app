import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';

class Reservation {
  final int? id;
  final String clienteId;
  final String pagada;
  final Ocurrence? ocurrence;

  Reservation({
    required this.id,
    required this.clienteId,
    required this.pagada,
    required this.ocurrence,
  });
}
