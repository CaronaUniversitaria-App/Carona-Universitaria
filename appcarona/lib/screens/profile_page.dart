import 'package:flutter/material.dart';
import 'package:appcarona/widgets/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: const ProfileForm(),
    );
  }
}
