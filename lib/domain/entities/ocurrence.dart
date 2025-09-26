import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class Ocurrence {
  final int id;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final String price;

  final bool isInPlan;

  final PilatesClass classSession;

  Ocurrence({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.price,

    required this.isInPlan,

    required this.classSession,
  });
}
