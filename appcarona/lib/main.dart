import 'package:flutter/material.dart';

void main() {
  runApp(const RideShareApp());
}

class RideShareApp extends StatelessWidget {
  const RideShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caronas Universitárias',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caronas Universitárias'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar caronas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions_car),
                  label: const Text('Oferecer Carona'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  label: const Text('Procurar Carona'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: const [
                  RideCard(
                    driver: 'Ana Silva',
                    from: 'Campus A',
                    to: 'Campus B',
                    time: '08:00 AM',
                  ),
                  RideCard(
                    driver: 'Carlos Souza',
                    from: 'Bairro Centro',
                    to: 'Universidade',
                    time: '09:30 AM',
                  ),
                  RideCard(
                    driver: 'Mariana Lopes',
                    from: 'Residencial Sul',
                    to: 'Campus C',
                    time: '14:00 PM',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RideCard extends StatelessWidget {
  final String driver;
  final String from;
  final String to;
  final String time;

  const RideCard({
    super.key,
    required this.driver,
    required this.from,
    required this.to,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.person, size: 40),
        title: Text('Motorista: $driver'),
        subtitle: Text('De: $from ➡ Para: $to\nHorário: $time'),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text('Detalhes'),
        ),
      ),
    );
  }
}
