class User {
  final int id;
  final String? name;
  final String? email;
  final String? pathology;
  final bool? isActive;
  final String? language;
  final DateTime? lastLoginAt;
  final String? birthdate;
  final String? gender;
  final String? phone;
  final String? documentType;
  final String? documentNumber;
  final String? businessName;
  final String? personType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const User({
    required this.id,
    this.name,
    this.email,
    this.pathology,
    this.isActive,
    this.language,
    this.lastLoginAt,
    this.birthdate,
    this.gender,
    this.phone,
    this.documentType,
    this.documentNumber,
    this.businessName,
    this.personType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
}