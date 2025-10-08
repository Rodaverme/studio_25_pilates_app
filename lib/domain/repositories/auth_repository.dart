import 'package:studio_25_pilates_app/domain/entities/user.dart';


abstract class AuthRepository{
  Future<User> login(String email, String password);
  Future<void> register(String name, String email, String password, String confirmedPassword);
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
