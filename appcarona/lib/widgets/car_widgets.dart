import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarListTile extends StatelessWidget {
  final CarModel car;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CarListTile({
    super.key,
    required this.car,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(car.name ?? ''),
      subtitle: Text('Placa: ${car.plate}, Cor: ${car.color}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}