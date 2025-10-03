import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/auth_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/user.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/client_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/auth/client_api.dart';

import 'package:studio_25_pilates_app/infrastructure/models/auth/login_response.dart';
import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

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
        final loginResponse = LoginResponse.fromJson(
          response.data,
        ); // Guardar token
        await TokenService.deleleteToken();
        await TokenService.saveToken(loginResponse.token);
        final user = ClientMapper.clientApitoEntity(loginResponse.client);
        print('Bienvenida ${user.name} Token ${loginResponse.token}');
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
Future<User> getCurrentClient() async {
  try {
    final response = await dio.get('/api/client/me');

    if (response.statusCode == 200 && response.data != null) {
      // Convertir la respuesta en un Map<String, dynamic>
      final data = Map<String, dynamic>.from(response.data);

      // Crear un Client a partir del JSON
      final client = Client.fromJson(data);

      // Mapear a User
      final user = ClientMapper.clientApitoEntity(client);
      print('El cliente actual es ${user.name}');

      return user;
    }

    throw Exception('Error al obtener el cliente');
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

    if (response.statusCode == 200) {
      print('Logout Exitoso');
    } else {
      print('El backend no confirmó el logout, pero limpiamos el token local');
    }

    await TokenService.deleleteToken(); // 👈 limpiar token local
  } on DioException catch (e) {
    // Si fue 401 (token inválido), igual borramos el token local
    if (e.response?.statusCode == 401) {
      await TokenService.deleleteToken();
    }
    throw Exception(
      'Error al cerrar sesión: ${e.response?.data ?? e.message}',
    );
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}

  
}