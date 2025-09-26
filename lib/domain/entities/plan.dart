class Plan {
  final int id;
  final String name;
  final bool isActive;
  final int classLimit;
  final String description;
  final String price;
  final bool allowGuests;
 

  Plan({
    required this.id,
    required this.name,
    required this.isActive,
    required this.price,
    required this.allowGuests,
    
    required this.description,
    required this.classLimit
  });
}
