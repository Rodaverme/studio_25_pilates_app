import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';
import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio = DioClient.Dio_create();

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/client/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final user = LoginResponse.fromJson(response.data);

        // Guardar token
        await TokenService.saveToken(user.token);

        print('Bienvenida ${user.client.name} Token ${user.token}');
        return user;
      }

      throw Exception('Error en el login');
    } on DioException catch (e) {
      throw Exception('Error en el Login: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<String> recoverPassword(String email) {
    throw UnimplementedError();
  }

  @override
  Future<void> register(
    String name,
    String email,
    String password,
    String confirmedPassword,
  ) async {
    try {
      final response = await dio.post(
        '/api/client/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmedPassword,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final user = LoginResponse.fromJson(response.data);

        // Guardar token
        await TokenService.saveToken(user.token);
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<Client> getCurrentClient() async {
    try {
      final token = await TokenService.getToken();
      if (token == null) throw Exception('No hay token guardado');

      final response = await dio.get(
        '/api/client/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Aquí asumo que tu backend devuelve algo compatible con Client
        return Client.fromJson(response.data['client']);
      }

      throw Exception('No se pudo obtener el cliente');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener el cliente: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      final response = await dio.post('/api/client/logout');

      if (response.statusCode == 200 && response.data != null) {
        print('Logout Exitoso');
      }

      throw Exception('Error al iniciar Sesion');
    } on DioException catch (e) {
      throw Exception(
        'Error al iniciar Sesion: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
