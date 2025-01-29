import 'package:flutter/material.dart';
import '../models/ride_model.dart';

class RideListTile extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const RideListTile({
    super.key,
    required this.ride,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Destino: ${ride.destination}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Vagas: ${ride.seats}'),
          Text('Paradas: ${ride.stops}'),
          Text('Oferecido por: ${ride.userName}'),
        ],
      ),
      trailing: ElevatedButton(
        onPressed: onAccept,
        child: const Text('Aceitar Carona'),
      ),
    );
  }
}