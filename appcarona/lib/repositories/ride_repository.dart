import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:appcarona/models/ride.dart';

class RideRepository {
  Future<List<Ride>> loadRides() async {
    final DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child('rides');
    final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    final DataSnapshot ridesSnapshot = await ridesRef.get();

    if (ridesSnapshot.exists) {
      final Map<dynamic, dynamic> ridesMap = ridesSnapshot.value as Map<dynamic, dynamic>;
      final List<Ride> loadedRides = [];

      for (var userId in ridesMap.keys) {
        final userRides = ridesMap[userId];
        if (userRides != null) {
          final Map<dynamic, dynamic> userRidesMap = userRides as Map<dynamic, dynamic>;

          final DataSnapshot userSnapshot = await usersRef.child(userId).get();
          final String userName = userSnapshot.child('name').value as String? ?? 'Usuário Desconhecido';

          for (var rideId in userRidesMap.keys) {
            final rideData = userRidesMap[rideId];
            final ride = Ride.fromJson(Map<String, dynamic>.from(rideData as Map));
            ride.userId = userId;
            ride.rideId = rideId;
            ride.userName = userName;
            loadedRides.add(ride);
          }
        }
      }

      return loadedRides;
    }

    return [];
  }

  Future<void> offerRide(Ride ride) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference ridesRef =
          FirebaseDatabase.instance.ref().child('rides').child(user.uid);

      await ridesRef.push().set(ride.toJson());
    }
  }

  Future<void> acceptRide(Ride ride) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DatabaseReference rideRef = FirebaseDatabase.instance
          .ref()
          .child('rides')
          .child(ride.userId!)
          .child(ride.rideId!)
          .child('acceptedBy');

      await rideRef.set(user.uid);
    }
  }

  Future<void> cancelRide(Ride ride) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && ride.userId == user.uid) {
      final DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child('rides');
      final DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('history');

      await historyRef.child(ride.userId!).child(ride.rideId!).set({
        ...ride.toJson(),
        'status': 'canceled',
      });

      await ridesRef.child(ride.userId!).child(ride.rideId!).remove();
    }
  }
}
