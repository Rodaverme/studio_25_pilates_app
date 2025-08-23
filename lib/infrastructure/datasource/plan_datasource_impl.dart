import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/plans_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/plan.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/plan_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/plan/plan_reponse.dart';

class PlanDatasourceImpl extends PlansDatasource {
  final Dio dio = DioClient.Dio_create();
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

      // 🔹 Si quieres el plan activo
      final activePlan = plans.firstWhere((p) => p.isActive, orElse: () => plans.first);

      final plan = PlanMapper.PlanApitoEntity(activePlan.plan);
      print('Tu plan es el siguiente ${plan.name}');
      return plan;
    }
    throw Exception('Error al obtener plan');
  } on DioException catch (e) {
    throw Exception('Error en el Login: ${e.response?.data ?? e.message}');
  } catch (e) {
    throw Exception('Error inesperado: $e');
  }
}
}
