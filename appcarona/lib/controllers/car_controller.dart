import '../models/car_model.dart';
import '../repositories/car_repository.dart';

class CarController {
  final CarRepository _carRepository = CarRepository();

  Future<void> addCar(String userId, CarModel car) async {
    await _carRepository.addCar(userId, car);
  }

  Future<List<CarModel>> getCars(String userId) async {
    return await _carRepository.getCars(userId);
  }

  Future<void> updateCar(String userId, CarModel car) async {
    await _carRepository.updateCar(userId, car);
  }

  Future<void> deleteCar(String userId, String carKey) async {
    await _carRepository.deleteCar(userId, carKey);
  }
}