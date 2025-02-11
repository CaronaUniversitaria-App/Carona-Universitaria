import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/controllers/car_management_controller.dart';

class CarList extends StatelessWidget {
  final List<Car> cars;
  final VoidCallback onCarDeleted;
  const CarList({super.key, required this.cars, required this.onCarDeleted});

  @override
  Widget build(BuildContext context) {
    final CarManagementController controller = CarManagementController();
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(cars[index].name ?? ''),
          subtitle: Text('Placa: ${cars[index].plate}, Cor: ${cars[index].color}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final carKey = cars[index].key;
              if (carKey != null) {
                await controller.removeCar(carKey);
                onCarDeleted();
              }
            },
          ),
        );
      },
    );
  }
}