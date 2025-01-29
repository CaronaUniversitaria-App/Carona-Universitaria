import 'package:firebase_database/firebase_database.dart';
import '../models/car_model.dart';

class CarRepository {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('cars');

  Future<void> addCar(String userId, CarModel car) async {
    await _dbRef.child(userId).push().set({
      'plate': car.plate,
      'name': car.name,
      'color': car.color,
    });
  }

  Future<List<CarModel>> getCars(String userId) async {
    final snapshot = await _dbRef.child(userId).get();
    if (snapshot.exists) {
      final cars = (snapshot.value as Map).entries.map((entry) {
        return CarModel(
          key: entry.key,
          plate: entry.value['plate'],
          name: entry.value['name'],
          color: entry.value['color'],
        );
      }).toList();
      return cars;
    }
    return [];
  }

  Future<void> updateCar(String userId, CarModel car) async {
    await _dbRef.child(userId).child(car.key!).update({
      'plate': car.plate,
      'name': car.name,
      'color': car.color,
    });
  }

  Future<void> deleteCar(String userId, String carKey) async {
    await _dbRef.child(userId).child(carKey).remove();
  }
}