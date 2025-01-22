import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carona UFBA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Carona UFBA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class RideOfferPage extends StatelessWidget {
  const RideOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oferecer Carona')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Destino')),
            TextField(decoration: const InputDecoration(labelText: 'Vagas Disponíveis')),
            TextField(decoration: const InputDecoration(labelText: 'Pontos de Parada')),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Oferecer Carona'),
            ),
          ],
        ),
      ),
    );
  }
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();
  final TextEditingController shiftController = TextEditingController();

  String profilePhoto = 'https://via.placeholder.com/150';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profilePhoto),
            ),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: courseController, decoration: const InputDecoration(labelText: 'Curso')),
            TextField(controller: shiftController, decoration: const InputDecoration(labelText: 'Turno')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aqui poderia ser implementado o salvamento dos dados
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dados salvos com sucesso!')),
                );
              },
              child: const Text('Salvar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Cadastrar-se'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Gerenciar Automóveis'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CarManagementPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Oferecer Carona'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RideOfferPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Meu Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.directions_car, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'Bem-vindo ao Carona UFBA!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Facilitando suas viagens de forma prática e segura.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Email UFBA')),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Cadastrar-se'),
            ),
          ],
        ),
      ),
    );
  }
}

class CarManagementPage extends StatefulWidget {
  const CarManagementPage({super.key});

  @override
  _CarManagementPageState createState() => _CarManagementPageState();
}

class _CarManagementPageState extends State<CarManagementPage> {
  final List<Map<String, String>> cars = [];
  final TextEditingController plateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  void addCar() {
    setState(() {
      cars.add({
        'Placa': plateController.text,
        'Nome': nameController.text,
        'Cor': colorController.text,
      });
      plateController.clear();
      nameController.clear();
      colorController.clear();
    });
  }

  void removeCar(int index) {
    setState(() {
      cars.removeAt(index);
    });
  }

  void editCar(int index) {
    plateController.text = cars[index]['Placa']!;
    nameController.text = cars[index]['Nome']!;
    colorController.text = cars[index]['Cor']!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Automóvel'),
        content: Column(
          children: [
            TextField(controller: plateController, decoration: const InputDecoration(labelText: 'Placa')),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Cor')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cars[index] = {
                  'Placa': plateController.text,
                  'Nome': nameController.text,
                  'Cor': colorController.text,
                };
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciar Automóveis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: plateController, decoration: const InputDecoration(labelText: 'Placa')),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Cor')),
            ElevatedButton(onPressed: addCar, child: const Text('Adicionar Automóvel')),
          ],
        ),
      ),
    );
  }
}
