import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class Plan {
  final int id;
  final String name;
  final bool isActive;
  final String description;
  final String price;
  final bool allowGuests;
  final dynamic guestLimitPerClass;
  final List<PilatesClass>?classes;
  

  Plan( {
    required this.id,
    required this.name,
    required this.isActive,
    required this.price,
    required this.allowGuests,
    required this.guestLimitPerClass,
    required this.description,
    this.classes
  });
}
