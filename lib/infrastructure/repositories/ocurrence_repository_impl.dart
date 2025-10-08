import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/domain/repositories/ocurrence_repository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/ocurrence_datasource_impl.dart';

class OcurrenceRepositoryImpl extends OcurrenceRepository {
  final OcurrenceDatasourceImpl datasourceImpl;

  OcurrenceRepositoryImpl({required this.datasourceImpl});

  @override
  Future<List<Ocurrence>> getAllOcurrence(DateTime from, DateTime to) {
    return datasourceImpl.getAllOcurrence(from,to);
  }

  @override
  Future<List<Ocurrence>> getOcurrencesByClassId(
    int classId,
    String from,
    String to,
  ) {
    return datasourceImpl.getOcurrencesByClassId(classId, from, to);
  }

  @override
  Future<List<Ocurrence>> getOcurrencesByClassPlan(
    int planId,
    String from,
    String to,
  ) {
    return datasourceImpl.getOcurrencesByClassPlan(planId, from, to);
  }

  @override
  Future<Ocurrence> getOcurrencesById(int id) {
    return datasourceImpl.getOcurrencesById(id);
  }
  
  @override
  Future<List<Ocurrence>> getAllOcurrenceByDay(DateTime day) {
    // TODO: implement getAllOcurrenceByDay
    throw UnimplementedError();
  }
  
  @override
  Future<List<Ocurrence>> getAvailableOcurrences(int ocurrenceId){
    // TODO: implement getAvailableOcurrences
    throw UnimplementedError();
  }
}
