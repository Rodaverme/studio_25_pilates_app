import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';

abstract class OcurrenceDatasouce  {
  Future<List<Ocurrence>>getAllOcurrence(DateTime from, DateTime to);
  Future<List<Ocurrence>>getAllOcurrenceByDay(DateTime day);
  Future<Ocurrence>getOcurrencesById(int id);
  Future<List<Ocurrence>>getOcurrencesByClassId(int classId,String from,String to);
  Future<List<Ocurrence>>getOcurrencesByClassPlan(int planId,String from,String to);

  
}