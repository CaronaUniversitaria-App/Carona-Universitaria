import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appcarona/repositories/car_repository.dart';
import 'package:appcarona/repositories/ride_repository.dart';

// Provider para CarRepository
final carRepositoryProvider = Provider<CarRepository>((ref) {
  return CarRepository();
});

// Provider para RideRepository
final rideRepositoryProvider = Provider<RideRepository>((ref) {
  return RideRepository();
});
