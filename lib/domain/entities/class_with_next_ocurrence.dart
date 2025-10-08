import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';

class ClassWithNextOcurrence {
  final PilatesClass pilatesClass;
  final Ocurrence? nextOccurrence;

  ClassWithNextOcurrence({
    required this.pilatesClass,
    required this.nextOccurrence,
  });
}
