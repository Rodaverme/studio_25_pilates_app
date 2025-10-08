import 'package:studio_25_pilates_app/domain/entities/user.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<void> register(
    String name,
    String email,
    String password,
    String confirmedPassword,
  );
  Future<String> recoverPassword(String email);
  Future<User> getCurrentClient();
  Future<void> updateUser(
    String name,
    String email,
    String avatarUrl,
    String language,
    String birthdate,
    String gender,
    String phone,
    String documentType,
    String documentNumber,
    String businessName,
    String pathology,
    String personType,
  );

  Future<Map<String, String>> getDocumentTypes();
  Future<Map<String, String>> getOrganizationTypes();
  Future<Map<String, String>> getGendertypes();

  Future<void> logOut();
}

// {
//   "name": "Juan Pérez",
//   "email": "juan.perez@example.com",
//   "avatar_url": "https://example.com/avatar.jpg", // por ahora no se va a cambiar
//   "language": "es", // por ahora no se va a cambiar
//   "birthdate": "1990-05-15", //yyyy-mm-dd o dd-mm-yyyy
//   "gender": "1", //1 = female (default), 2 = male, 3 = other
//   "phone": "+57 300 123 4567",
//   "document_type": "6", // "3"=Cédula de ciudadanía, "1"=Registro civil, "2"=Tarjeta de identidad, "4"=Tarjeta de extranjería, "5"=Cédula de extranjería, "7=Pasaporte, "8"=Documento de identificación extranjero, "9"=NIT de otro país, "10"=NUIP, "11"=PEP
//   "document_number": "123456789",
//   "business_name": "Juan Pérez",
//   "pathology": "patologia y/o condicion",
//   "person_type": "1" // 1 = juridical o 2 = natural
// }
