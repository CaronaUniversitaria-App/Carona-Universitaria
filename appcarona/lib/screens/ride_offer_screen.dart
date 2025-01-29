import 'package:flutter/material.dart';
import '../controllers/ride_controller.dart';
import '../models/ride_model.dart';

class RideOfferScreen extends StatefulWidget {
  const RideOfferScreen({super.key});

  @override
  _RideOfferScreenState createState() => _RideOfferScreenState();
}

class _RideOfferScreenState extends State<RideOfferScreen> {
  final RideController _rideController = RideController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController stopsController = TextEditingController();
  final TextEditingController departureLocationController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();
  String? selectedCar;
  String? selectedSeats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oferecer Carona')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: departureLocationController,
              decoration: const InputDecoration(labelText: 'Local de Saída'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: departureTimeController,
              decoration: const InputDecoration(labelText: 'Horário de Saída'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: destinationController,
              decoration: const InputDecoration(labelText: 'Destino'),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedSeats,
              items: List.generate(8, (index) {
                return DropdownMenuItem(
                  value: index.toString(),
                  child: Text('$index vagas'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedSeats = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Vagas Disponíveis'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: stopsController,
              decoration: const InputDecoration(labelText: 'Pontos de Parada'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final ride = RideModel(
                  departureLocation: departureLocationController.text,
                  departureTime: departureTimeController.text,
                  destination: destinationController.text,
                  seats: selectedSeats,
                  stops: stopsController.text,
                );

                await _rideController.offerRide('userId', ride);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Carona oferecida com sucesso!')),
                );
              },
              child: const Text('Oferecer Carona'),
            ),
          ],
        ),
      ),
    );
  }
}