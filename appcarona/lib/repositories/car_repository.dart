import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:appcarona/models/car.dart';

class CarRepository {
  Future<List<Car>> loadCars() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      final DataSnapshot snapshot = await carsRef.get();

      if (snapshot.exists) {
        final Map<dynamic, dynamic> carsMap = snapshot.value as Map<dynamic, dynamic>;
        final List<Car> loadedCars = [];

        carsMap.forEach((key, value) {
          final car = Car.fromJson(Map<String, dynamic>.from(value as Map));
          car.key = key;
          loadedCars.add(car);
        });

        return loadedCars;
      }
    }

    return [];
  }

  Future<void> addCar(Car car) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      final carData = car.toJson();

      await carsRef.push().set(carData);
    }
  }

  Future<void> removeCar(String carKey) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      await carsRef.child(carKey).remove();
    }
  }

  Future<void> updateCar(String carKey, Car car) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      await carsRef.child(carKey).update(car.toJson());
    }
  }
}
