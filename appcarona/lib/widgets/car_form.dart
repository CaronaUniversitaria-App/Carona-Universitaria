import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/controllers/car_management_controller.dart';

class CarForm extends ConsumerWidget {
  final VoidCallback onCarAdded;
  const CarForm({super.key, required this.onCarAdded});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plateController = TextEditingController();
    final nameController = TextEditingController();
    final colorController = TextEditingController();

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

            await ref.read(carManagementProvider.notifier).addCar(car); // ✅ Correção aqui!
            
            onCarAdded();
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
