import 'package:firebase_database/firebase_database.dart';
import '../models/ride_model.dart';

class RideRepository {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('rides');

  Future<void> offerRide(String userId, RideModel ride) async {
    await _dbRef.child(userId).push().set({
      'departureLocation': ride.departureLocation,
      'departureTime': ride.departureTime,
      'destination': ride.destination,
      'seats': ride.seats,
      'stops': ride.stops,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<RideModel>> getRides() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final rides = (snapshot.value as Map).entries.map((entry) {
        return RideModel(
          userId: entry.key,
          rideId: entry.key,
          departureLocation: entry.value['departureLocation'],
          departureTime: entry.value['departureTime'],
          destination: entry.value['destination'],
          seats: entry.value['seats'],
          stops: entry.value['stops'],
        );
      }).toList();
      return rides;
    }
    return [];
  }

  Future<void> cancelRide(String userId, String rideId) async {
    await _dbRef.child(userId).child(rideId).remove();
  }
}