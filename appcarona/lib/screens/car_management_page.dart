import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/controllers/car_management_controller.dart';
import 'package:appcarona/widgets/car_list.dart';
import 'package:appcarona/widgets/car_form.dart';

class CarManagementPage extends StatefulWidget {
  const CarManagementPage({super.key});

  @override
  _CarManagementPageState createState() => _CarManagementPageState();
}

class _CarManagementPageState extends State<CarManagementPage> {
  final List<Car> cars = [];
  final CarManagementController _controller = CarManagementController();

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    final loadedCars = await _controller.loadCars();
    setState(() {
      cars.clear();
      cars.addAll(loadedCars);
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
            CarForm(onCarAdded: () {
              loadCars();
            }),
            const SizedBox(height: 20),
            Expanded(
              child: CarList(cars: cars, onCarDeleted: () {
                loadCars();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
