import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/plans_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/plan_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_api.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_reponse.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/status_plan.dart';

class PlanDatasourceImpl extends PlansDatasource {
  final Dio dio = DioClient.Dio_create();

  PlanDatasourceImpl(
    
  );

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

        final plans = data.map((e) => PlansResponse.fromJson(e)).toList();

        final activePlan = plans.firstWhere(
          (p) => p.isActive,
          orElse: () => plans.first,
        );

        final plan = PlanMapper.planApitoEntity(
          activePlan.plan,
         
        );
        print('Tu plan es el siguiente ${plan.name}');
        return plan;
      }
      throw Exception('Error al obtener plan');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener mi plan: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
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
            .map(
              (json) => PlanMapper.planApitoEntity(
                PlansApi.fromJson(json)
               
              ),
            )
            .toList();

        print('Estos son los planes que existen ${plans.first}');
        return plans;
      }
      throw Exception('Error al obtener plan');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todos los planes: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<StatusPlan> statusPlan() async {
    try {
      final response = await dio.get('/api/client/plan-status');
      print('JSON recibido: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        final statusPlan = StatusPlan.fromJson(response.data);
        print('Plan: ${statusPlan.plan.name}');
        print('Días restantes: ${statusPlan.daysRemaining}');
        return statusPlan;
      }

      throw Exception('Error al obtener estado del plan');
    } on DioException catch (e) {
      throw Exception('Error en statusPlan: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Error inesperado en statusPlan: $e');
    }
  }
}
