import 'package:flutter/material.dart';
import 'package:appcarona/models/car.dart';
import 'package:appcarona/controllers/ride_offer_controller.dart';
import 'package:appcarona/widgets/ride_offer_form.dart' show RideOfferForm;
import 'package:appcarona/repositories/ride_repository.dart';
import 'package:appcarona/repositories/car_repository.dart';

class RideOfferPage extends StatefulWidget {
  const RideOfferPage({super.key});

  @override
  _RideOfferPageState createState() => _RideOfferPageState();
}

class _RideOfferPageState extends State<RideOfferPage> {
  List<Car> cars = [];
  final RideOfferController _controller = RideOfferController(
    rideRepository: RideRepository(),
    carRepository: CarRepository(),
  ); // Correct

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
      appBar: AppBar(title: const Text('Oferecer Carona')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RideOfferForm(
          cars: cars,
          onRideOffered: () {
            // Callback para atualizar a lista ou realizar outra ação após oferecer a carona.
          },
        ),
      ),
    );
  }
}
