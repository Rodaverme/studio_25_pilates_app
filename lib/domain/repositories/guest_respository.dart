import 'package:studio_25_pilates_app/infrastructure/models/guest/guest_response.dart';

abstract class GuestRespository {
  Future<List<GuestResponse>> getAllGuest();
  Future<List<GuestResponse>> getAllGuestById(int id);
  Future<void> createGuest(
    String name,
    String document,
    String? email,
    String? phone,
    int reservationId
  );
}
