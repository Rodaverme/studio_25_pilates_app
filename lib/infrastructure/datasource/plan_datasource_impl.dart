import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/plans_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/plans/plan_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_reponse.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';

class PlanDatasourceImpl extends PlansDatasource {
  final Dio dio = DioClient.Dio_create();

  PlanDatasourceImpl();

  @override
  Future<void> cancelMyPlan() {
    // TODO: implement cancelMyPlan
    throw UnimplementedError();
  }

  @override
  Future<Plan> getMyPlan() async {
    try {
      final response = await dio.get('/api/client/plans');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;

        final plans = data.map((e) => PlanResponse.fromJson(e)).toList();

        final activePlan = plans.firstWhere(
          (p) => p.isActive!,
          orElse: () => plans.first,
        );

        final plan = PlanMapper.planApitoEntity(activePlan);

        return plan;
      }
      throw Exception('Error al obtener My Plan');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener mi plan: ${e.response?.data ?? e.message}',
      );
    } catch (e,st) {
      print("❌ Error parseando My Plan Plan: $e");
      print("STACK: $st");
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<Plan>> getAllPlans() async {
    try {
      final response = await dio.get('/api/plans');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<Plan> plans = data
            .map((json) => PlanMapper.planApitoEntity(PlanResponse.fromJson(json)))
            .toList();

        return plans;
      }
      throw Exception('Error al obtener plan');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todos los planes: ${e.response?.data ?? e.message}',
      );
    } catch (e,st) {
      print("❌ Error parseando StatusPlan: $e");
      print("STACK: $st");
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<StatusPlan> statusPlan() async {
    try {
      final response = await dio.get('/api/client/plan-status');

      if (response.statusCode == 200 && response.data != null) {
        final statusPlan = StatusPlan.fromJson(response.data);

        return statusPlan;
      }

      throw Exception('Error al obtener estado del plan');
    } on DioException catch (e) {
      throw Exception('Error en statusPlan: ${e.response?.data ?? e.message}');
    } catch (e, st) {
      print("❌ Error parseando StatusPlan: $e");
      print("STACK: $st");
      throw Exception('Error inesperado en statusPlan: $e');
    }
  }

  @override
  Future<Plan> getPlanById(int planId) async {
    try {
      final response = await dio.get('/api/plans/$planId');

      if (response.statusCode == 200 && response.data != null) {
        final planResponse = PlanResponse.fromJson(response.data);

        final plan = PlanMapper.planApitoEntity(planResponse);

        return plan;
      }
      throw Exception('Error al obtener plan');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener mi plan: ${e.response?.data ?? e.message}',
      );
    } catch (e,st) {
      print("❌ Error parseando PlanById: $e");
      print("STACK: $st");
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> planPurchase(int planId, int cardId) async {
    try {
      final response = await dio.post(
        '/api/plans/$planId/purchase',
        data: {"card_id": cardId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Pago Exitoso');
        return;
      }
      throw Exception('Error al hacer el pago del plan ');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener la reserva: ${e.response?.data ?? e.message}',
      );
    } catch (e,st) {
      print("❌ Error parseando StatusPlan: $e");
      print("STACK: $st");
      throw Exception('Error inesperado: $e');
    }
  }
}
