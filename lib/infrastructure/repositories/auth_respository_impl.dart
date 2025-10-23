import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/user.dart';
import 'package:studio_25_pilates_app/domain/repositories/auth_repository.dart';

class AuthRespositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRespositoryImpl({required this.datasource});

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<String> recoverPassword(String email) {
    return datasource.recoverPassword(email);
  }

  @override
  Future<void> register(
    String name,
    String email,
    String password,
    String confirmerPassword,
  ) {
    return datasource.register(name, email, password, confirmerPassword);
  }

  @override
  Future<User> getCurrentClient() {
    return datasource.getCurrentClient();
  }

  @override
  Future<void> logOut() {
    return datasource.logOut();
  }

  @override
  Future<Map<String, String>> getDocumentTypes() {
    return datasource.getDocumentTypes();
  }

  @override
  Future<Map<String, String>> getGendertypes() {
    return datasource.getGendertypes();
  }

  @override
  Future<Map<String, String>> getOrganizationTypes() {
    return datasource.getOrganizationTypes();
  }

  @override
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
  ) {
    return updateUser(
      name,
      email,
      avatarUrl,
      language,
      birthdate,
      gender,
      phone,
      documentType,
      documentNumber,
      businessName,
      pathology,
      personType,
    );
  }
  
}
