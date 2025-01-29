import 'package:flutter/material.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_model.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  _RideHistoryScreenState createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  final RideController _rideController = RideController();
  List<RideModel> historyRides = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final loadedHistory = await _rideController.getRides(); // Ajuste conforme necessário
    setState(() {
      historyRides = loadedHistory;
    });
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
                return ListTile(
                  title: Text('Destino: ${ride.destination}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vagas: ${ride.seats}'),
                      Text('Paradas: ${ride.stops}'),
                      Text('Status: ${ride.status}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}