
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/repositories/ride_repository.dart';

class RideListController {
  final RideRepository _rideRepository;

  RideListController({RideRepository? rideRepository})
      : _rideRepository = rideRepository ?? RideRepository();

  Future<List<Ride>> loadRides() async {
    return await _rideRepository.loadRides();
  }

  Future<void> acceptRide(Ride ride) async {
    await _rideRepository.acceptRide(ride);
  }

  Future<void> cancelRide(Ride ride) async {
    await _rideRepository.cancelRide(ride);
  }
}