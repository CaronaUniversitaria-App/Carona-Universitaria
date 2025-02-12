import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';

class CarList extends StatelessWidget {
  final List<Car> cars;
  final VoidCallback onCarDeleted;

  const CarList({
    super.key,
    required this.cars,
    required this.onCarDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return ListTile(
          // Se car.name for nulo, exibirá "Unnamed Car"
          title: Text(car.name ?? 'Unnamed Car'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onCarDeleted,
          ),
        );
      },
    );
  }
}
