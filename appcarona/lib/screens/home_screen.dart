// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../widgets/auth_widgets.dart'; // Importe o AuthButton aqui
import './main_screen.dart'; // Importe o MainScreen aqui

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = AuthController();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = _authController.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carona UFBA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo ao Carona UFBA!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (user == null)
              AuthButton(
                onPressed: () async {
                  final user = await _authController.signInWithGoogle(context);
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                    );
                  }
                },
                icon: Icons.login,
                label: 'Login com Google',
              )
            else
              AuthButton(
                onPressed: () async {
                  await _authController.signOut();
                  setState(() {
                    user = null;
                  });
                },
                icon: Icons.exit_to_app,
                label: 'Logout',
              ),
          ],
        ),
      ),
    );
  }
}