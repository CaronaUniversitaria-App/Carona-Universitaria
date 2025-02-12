import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/repositories/ride_repository.dart';
import 'package:appcarona/repositories/car_repository.dart';
import 'package:appcarona/repositories/repository_providers.dart';

// Provider para RideOfferController
final rideOfferProvider = Provider<RideOfferController>((ref) {
  final rideRepository = ref.read(rideRepositoryProvider);
  final carRepository = ref.read(carRepositoryProvider);
  return RideOfferController(
    rideRepository: rideRepository, 
    carRepository: carRepository,
  );
});

class RideOfferController {
  final RideRepository _rideRepository;
  final CarRepository _carRepository;

  RideOfferController({
    required RideRepository rideRepository,
    required CarRepository carRepository,
  })  : _rideRepository = rideRepository,
        _carRepository = carRepository;

  Future<List<Car>> loadCars() {
    return _carRepository.loadCars();
  }

  Future<void> offerRide(Ride ride) {
    return _rideRepository.offerRide(ride);
  }
}