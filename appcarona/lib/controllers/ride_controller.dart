import '../models/ride_model.dart';
import '../repositories/ride_repository.dart';

class RideController {
  final RideRepository _rideRepository = RideRepository();

  Future<void> offerRide(String userId, RideModel ride) async {
    await _rideRepository.offerRide(userId, ride);
  }

  Future<List<RideModel>> getRides() async {
    return await _rideRepository.getRides();
  }

  Future<void> cancelRide(String userId, String rideId) async {
    await _rideRepository.cancelRide(userId, rideId);
  }
}