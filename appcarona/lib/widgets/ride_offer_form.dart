import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/models/ride.dart';
import 'package:appcarona/controllers/ride_offer_controller.dart';

class RideOfferForm extends StatefulWidget {
  final List<Car> cars;
  final VoidCallback onRideOffered;

  const RideOfferForm({super.key, required this.cars, required this.onRideOffered});

  @override
  _RideOfferFormState createState() => _RideOfferFormState();
}

class _RideOfferFormState extends State<RideOfferForm> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController stopsController = TextEditingController();
  final TextEditingController departureLocationController = TextEditingController();
  final TextEditingController departureTimeController = TextEditingController();

  String? selectedCarKey;
  String? selectedSeats;
  final RideOfferController _controller = RideOfferController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedCarKey,
          items: widget.cars.map((car) {
            return DropdownMenuItem<String>(
              value: car.key,
              child: Text('${car.name} (${car.plate})'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCarKey = value;
            });
          },
          decoration: const InputDecoration(labelText: 'Selecionar Automóvel'),
        ),
        const SizedBox(height: 20),
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
            final ride = Ride(
              carKey: selectedCarKey,
              departureLocation: departureLocationController.text,
              departureTime: departureTimeController.text,
              destination: destinationController.text,
              seats: selectedSeats,
              stops: stopsController.text,
              timestamp: DateTime.now().toIso8601String(),
            );

            await _controller.offerRide(ride);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Carona oferecida com sucesso!')),
            );

            setState(() {
              departureLocationController.clear();
              departureTimeController.clear();
              destinationController.clear();
              stopsController.clear();
              selectedCarKey = null;
              selectedSeats = null;
            });
            widget.onRideOffered();
          },
          child: const Text('Oferecer Carona'),
        ),
      ],
    );
  }
}
