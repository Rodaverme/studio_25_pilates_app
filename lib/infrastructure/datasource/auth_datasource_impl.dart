import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/user.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/client_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/client_api.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';
import 'package:studio_25_pilates_app/presentation/helpers/app_error.dart';
import 'package:studio_25_pilates_app/presentation/helpers/error_handler.dart';
import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

// 👇 Importamos nuestro manejador de errores


class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio = DioClient.Dio_create();

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/client/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginResponse = LoginResponse.fromJson(response.data);
        await TokenService.deleleteToken();
        await TokenService.saveToken(loginResponse.token);
        final user = ClientMapper.clientApitoEntity(loginResponse.client);
        print('Bienvenida ${user.name} Token ${loginResponse.token}');
        return user;
      }

      throw AppError("Error desconocido al iniciar sesión.");
    } catch (e) {
      throw ErrorHandler.handle(e); // 👈 Traducción clara
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
        await TokenService.saveToken(user.token);
      } else {
        throw AppError("Error desconocido al registrarse.");
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<User> getCurrentClient() async {
    try {
      final response = await dio.get('/api/client/me');

      if (response.statusCode == 200 && response.data != null) {
        final data = Map<String, dynamic>.from(response.data);
        final client = Client.fromJson(data);
        final user = ClientMapper.clientApitoEntity(client);
        print('El cliente actual es ${user.name}');
        return user;
      }

      throw AppError("No se pudo obtener el cliente actual.");
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<void> logOut() async {
    try {
      final response = await dio.post('/api/client/logout');

      if (response.statusCode == 200) {
        print('Logout Exitoso');
      } else {
        print('El backend no confirmó el logout, pero limpiamos el token local');
      }

      await TokenService.deleleteToken();
    } catch (e) {
      // Si fue 401 (token inválido), igual borramos el token
      if (e is DioException && e.response?.statusCode == 401) {
        await TokenService.deleleteToken();
      }
      throw ErrorHandler.handle(e);
    }
  }
}
