import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/controllers/car_management_controller.dart';

class CarForm extends StatefulWidget {
  final VoidCallback onCarAdded;
  const CarForm({super.key, required this.onCarAdded});

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final TextEditingController plateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final CarManagementController controller = CarManagementController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: plateController, decoration: const InputDecoration(labelText: 'Placa')),
        TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
        TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Cor')),
        ElevatedButton(
          onPressed: () async {
            final car = Car(
              plate: plateController.text,
              name: nameController.text,
              color: colorController.text,
            );

            await controller.addCar(car);
            widget.onCarAdded();
            plateController.clear();
            nameController.clear();
            colorController.clear();
          },
          child: const Text('Adicionar Automóvel'),
        ),
      ],
    );
  }
}
