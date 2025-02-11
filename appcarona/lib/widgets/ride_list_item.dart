import 'package:flutter/material.dart';
import 'package:appcarona/models/ride.dart';

class RideListItem extends StatelessWidget {
  final Ride ride;
  final VoidCallback onAccept;
  final VoidCallback onCancel;
  final bool isCurrentUserRide;

  const RideListItem({
    super.key,
    required this.ride,
    required this.onAccept,
    required this.onCancel,
    required this.isCurrentUserRide,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Destino: ${ride.destination}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Local de Saída: ${ride.departureLocation}'),
          Text('Horário de Saída: ${ride.departureTime}'),
          Text('Vagas: ${ride.seats}'),
          Text('Paradas: ${ride.stops}'),
          Text('Oferecido por: ${ride.userName}'),
        ],
      ),
      trailing: isCurrentUserRide
          ? ElevatedButton(
              onPressed: onCancel,
              child: const Text('Cancelar Carona'),
            )
          : ElevatedButton(
              onPressed: onAccept,
              child: const Text('Aceitar Carona'),
            ),
    );
  }
}