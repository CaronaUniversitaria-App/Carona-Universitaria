import 'package:flutter/material.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_model.dart';
import '../widgets/ride_widgets.dart';

class RideListScreen extends StatefulWidget {
  const RideListScreen({super.key});

  @override
  _RideListScreenState createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  final RideController _rideController = RideController();
  List<RideModel> rides = [];

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
    final loadedRides = await _rideController.getRides();
    setState(() {
      rides = loadedRides;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caronas Disponíveis')),
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (context, index) {
          final ride = rides[index];
          return RideListTile(
            ride: ride,
            onAccept: () {
              // Lógica para aceitar a carona
            },
            onCancel: () {
              // Lógica para cancelar a carona
            },
          );
        },
      ),
    );
  }
}