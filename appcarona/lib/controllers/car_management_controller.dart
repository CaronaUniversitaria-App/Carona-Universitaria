import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/repositories/car_repository.dart';

class CarManagementController extends StateNotifier<List<Car>> {
  final CarRepository _carRepository;

  CarManagementController(this._carRepository) : super([]) {
    loadCars();
  }

  Future<void> loadCars() async {
    state = await _carRepository.loadCars();
  }

  Future<void> addCar(Car car) async {
    await _carRepository.addCar(car);
    loadCars(); // Atualiza a lista de carros
  }
  Future<void> removeCar(String carKey) async {
    await _carRepository.removeCar(carKey); // Remove o carro do repositório
    loadCars(); // Atualiza a lista de carros
  }
  Future<List<Car>> loadedCars() async {
    // Assuming _carRepository.loadCars() returns Future<List<Car>>
    return await _carRepository.loadCars(); // Return the list of cars!
  }
}

final carManagementProvider =
    StateNotifierProvider<CarManagementController, List<Car>>(
  (ref) => CarManagementController(CarRepository()),
);
