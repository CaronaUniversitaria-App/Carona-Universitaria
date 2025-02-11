import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      setState(() {
        user = userCredential.user;
      });

      if (user != null && user!.email!.endsWith('@ufba.br')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(user: user),
          ),
        );
      } else {
        await FirebaseAuth.instance.signOut();
        setState(() {
          user = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Apenas e-mails da UFBA são permitidos.'),
          ),
        );
      }
      return user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')),
      );
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      user = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Desconectado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
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
              ElevatedButton.icon(
                onPressed: () => signInWithGoogle(context),
                icon: const Icon(Icons.login),
                label: const Text('Login com Google'),
              )
            else
              ElevatedButton.icon(
                onPressed: signOut,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Logout'),
              ),
          ],
        ),
      ),
    );
  }
}
