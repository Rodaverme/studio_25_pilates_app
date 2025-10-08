import 'package:studio_25_pilates_app/domain/entities/user.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/client_api.dart';

class ClientMapper {
  static User clientApitoEntity(Client client) => User(
    id: client.id ,
    name: client.name,
    email: client.email,
    phone: client.phone ?? '',
    birthdate: client.birthdate ?? '',
    businessName: client.businessName,
    createdAt: client.createdAt,
    deletedAt: client.deletedAt,
    documentNumber: client.documentNumber,
    documentType: client.documentType,
    gender: client.gender,
    isActive: client.isActive,
    language: client.language,
    lastLoginAt: client.lastLoginAt,
    pathology: client.pathology,
    personType: client.personType,
    updatedAt: client.updatedAt,
  );
}
