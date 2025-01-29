import 'package:flutter/material.dart';
import '../controllers/car_controller.dart';
import '../models/car_model.dart';
import '../widgets/car_widgets.dart';

class CarManagementScreen extends StatefulWidget {
  const CarManagementScreen({super.key});

  @override
  _CarManagementScreenState createState() => _CarManagementScreenState();
}

class _CarManagementScreenState extends State<CarManagementScreen> {
  final CarController _carController = CarController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  List<CarModel> cars = [];

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    final loadedCars = await _carController.getCars('userId'); // Ajuste o userId conforme necessário
    setState(() {
      cars = loadedCars;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Automóveis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: plateController,
              decoration: const InputDecoration(labelText: 'Placa'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: 'Cor'),
            ),
            ElevatedButton(
              onPressed: () async {
                final car = CarModel(
                  plate: plateController.text,
                  name: nameController.text,
                  color: colorController.text,
                );
                await _carController.addCar('userId', car); // Ajuste o userId
                setState(() {
                  cars.add(car);
                });
              },
              child: const Text('Adicionar Automóvel'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final car = cars[index];
                  return CarListTile(
                    car: car,
                    onEdit: () {
                      // Lógica para editar o carro
                    },
                    onDelete: () {
                      // Lógica para deletar o carro
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}