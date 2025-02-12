import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';

class RideOfferForm extends StatelessWidget {
  final List<Car> cars;
  final VoidCallback onRideOffered;

  const RideOfferForm({
    super.key,
    required this.cars,
    required this.onRideOffered,
  });

  @override
  Widget build(BuildContext context) {
    // Implemente o layout do formulário
    return Column(
      children: [
        // Exemplo: listagem simples dos carros disponíveis
        ListView.builder(
          shrinkWrap: true,
          itemCount: cars.length,
          itemBuilder: (context, index) {
            final car = cars[index];
            return ListTile(title: Text(car.name ?? 'Unnamed Car'));
          },
        ),
        ElevatedButton(
          onPressed: onRideOffered,
          child: const Text('Oferecer Carona'),
        ),
      ],
    );
  }
}
