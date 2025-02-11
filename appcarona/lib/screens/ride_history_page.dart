import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/widgets/ride_history_item.dart';

class RideHistoryPage extends StatefulWidget {
  const RideHistoryPage({super.key});

  @override
  _RideHistoryPageState createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  List<Ride> historyRides = [];
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    if (currentUser != null) {
      final DatabaseReference historyRef =
          FirebaseDatabase.instance.ref().child('history').child(currentUser!.uid);

      final DataSnapshot historySnapshot = await historyRef.get();

      if (historySnapshot.exists) {
        final Map<dynamic, dynamic> historyMap =
            historySnapshot.value as Map<dynamic, dynamic>;
        final List<Ride> loadedHistory = historyMap.entries.map((entry) {
          final ride = Ride.fromJson(Map<String, dynamic>.from(entry.value as Map));
          ride.rideId = entry.key;
          return ride;
        }).toList();

        setState(() {
          historyRides = loadedHistory;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Caronas')),
      body: historyRides.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma carona no histórico.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: historyRides.length,
              itemBuilder: (context, index) {
                final ride = historyRides[index];
                return RideHistoryItem(ride: ride);
              },
            ),
    );
  }
}
