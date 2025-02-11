import 'package:appcarona/models/ride.dart';
import 'package:appcarona/repositories/ride_repository.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/repositories/car_repository.dart';

class RideOfferController {
  final RideRepository _rideRepository = RideRepository();
  final CarRepository _carRepository = CarRepository();

  Future<List<Car>> loadCars() async {
    return await _carRepository.loadCars();
  }

  Future<void> offerRide(Ride ride) async {
    await _rideRepository.offerRide(ride);
  }
}
