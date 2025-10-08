import 'package:studio_25_pilates_app/domain/repositories/guest_respository.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/guest_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/models/guest/guest_response.dart';

class GuestRepositoryImpl extends GuestRespository {

final datasource = GuestDatasourceImpl();

  
  @override
  Future<void> createGuest(String name, String document, String? email, String? phone,int reservationId) {
    return datasource.createGuest(name, document, email, phone,reservationId);
  }

  @override
  Future<List<GuestResponse>> getAllGuest() {
    return datasource.getAllGuest();
  }

  @override
  Future<List<GuestResponse>> getAllGuestById(int id) {
   return datasource.getAllGuestById(id);
  }
  
}