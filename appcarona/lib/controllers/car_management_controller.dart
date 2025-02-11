import 'package:appcarona/models/car.dart';
import 'package:appcarona/repositories/car_repository.dart';

class CarManagementController {
  final CarRepository _carRepository = CarRepository();

  Future<List<Car>> loadCars() async {
    return await _carRepository.loadCars();
  }

  Future<void> addCar(Car car) async {
    await _carRepository.addCar(car);
  }

  Future<void> removeCar(String carKey) async {
    await _carRepository.removeCar(carKey);
  }

  Future<void> updateCar(String carKey, Car car) async {
    await _carRepository.updateCar(carKey, car);
  }
}
