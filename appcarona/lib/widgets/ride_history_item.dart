import 'package:flutter/material.dart';
import 'package:appcarona/models/ride.dart';

class RideHistoryItem extends StatelessWidget {
  final Ride ride;

  const RideHistoryItem({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
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
  }
}
