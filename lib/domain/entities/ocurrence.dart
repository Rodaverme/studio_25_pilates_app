import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class Ocurrence {
  final int id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int capacity;
  final String price;
  final bool isSpecial;
  final bool isCancelled;
  final bool isInPlan;
  final int reservedCount;
  final PilatesClass classSession;

  Ocurrence({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.price,
    required this.isSpecial,
    required this.isCancelled,
    required this.isInPlan,
    required this.reservedCount,
    required this.classSession,
  });
}
