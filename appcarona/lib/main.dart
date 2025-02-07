import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
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

      if (user != null && user!.email!.endsWith('@gmail.com')) {
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

class MainScreen extends StatelessWidget {
  final User? user;
  const MainScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user?.photoURL ?? ''),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Olá, ${user?.displayName ?? 'Usuário'}!',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Meu Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Oferecer Carona'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RideOfferPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Gerenciar Automóveis'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CarManagementPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Caronas Disponíveis'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RideListPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Caronas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RideHistoryPage(),
                  ),
                );
              },
            ),ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(title: 'Carona UFBA'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.directions_car,
          size: 100,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          'Bem-vindo ao Carona UFBA!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
  final TextEditingController shiftController = TextEditingController();
  String profilePhoto = 'https://via.placeholder.com/150';
  String? selectedCourse;
  List<String> courses = [
    "ADMINISTRAÇÃO",
    "ADMINISTRAÇÃO PÚBLICA",
    "ADMINISTRAÇÃO PÚBLICA E GESTÃO SOCIAL",
    "ARQUITETURA E URBANISMO",
    "ARQUIVOLOGIA",
    "ARTES CÊNICAS - DIREÇÃO TEATRAL",
    "ARTES CÊNICAS - INTERPRETAÇÃO TEATRAL",
    "ARTES VISUAIS",
    "BIBLIOTECONOMIA",
    "BIBLIOTECONOMIA E DOCUMENTAÇÃO",
    "BIOTECNOLOGIA",
    "CANTO LÍRICO",
    "CIÊNCIA DA COMPUTAÇÃO",
    "CIÊNCIAS BIOLÓGICAS",
    "CIÊNCIAS CONTÁBEIS",
    "CIÊNCIAS ECONÔMICAS",
    "CIÊNCIAS NATURAIS",
    "CIÊNCIAS SOCIAIS",
    "COMPOSIÇÃO E REGÊNCIA",
    "COMPUTAÇÃO",
    "COMUNICAÇÃO - PRODUÇÃO EM COMUNICAÇÃO E CULTURA",
    "DANÇA",
    "DESENHO E PLÁSTICA",
    "DESIGN",
    "DESIGN DE INTERIORES",
    "DIREITO",
    "EDUCAÇÃO DO CAMPO",
    "EDUCAÇÃO FÍSICA",
    "EDUCAÇÃO INTERCULTURAL INDÍGENA",
    "ENFERMAGEM",
    "ENGENHARIA CIVIL",
    "ENGENHARIA DA COMPUTAÇÃO",
    "ENGENHARIA DE AGRIMENSURA E CARTOGRÁFICA",
    "ENGENHARIA DE CONTROLE E AUTOMAÇÃO DE PROCESSOS",
    "ENGENHARIA DE MINAS",
    "ENGENHARIA DE PETRÓLEO",
    "ENGENHARIA DE PRODUÇÃO",
    "ENGENHARIA DE TRANSPORTES",
    "ENGENHARIA ELÉTRICA",
    "ENGENHARIA MECÂNICA",
    "ENGENHARIA QUÍMICA",
    "ENGENHARIA SANITÁRIA E AMBIENTAL",
    "ESTATÍSTICA",
    "ESTUDOS DE GÊNERO E DIVERSIDADE",
    "FARMÁCIA",
    "FILOSOFIA",
    "FÍSICA",
    "FISIOTERAPIA",
    "FONOAUDIOLOGIA",
    "GASTRONOMIA",
    "GEOFÍSICA",
    "GEOGRAFIA",
    "GEOLOGIA",
    "GESTÃO DO TURISMO E DESENVOLVIMENTO SUSTENTÁVEL",
    "HISTÓRIA",
    "INSTRUMENTO",
    "INTERDISCIPLINAR EM ARTES",
    "INTERDISCIPLINAR EM CIÊNCIA E TECNOLOGIA",
    "INTERDISCIPLINAR EM CIÊNCIA, TECNOLOGIA E INOVAÇÃO",
    "INTERDISCIPLINAR EM HUMANIDADES",
    "INTERDISCIPLINAR EM SAÚDE",
    "JORNALISMO",
    "LETRAS",
    "MATEMÁTICA",
    "MEDICINA",
    "MEDICINA VETERINÁRIA",
    "MUSEOLOGIA",
    "MÚSICA",
    "MÚSICA POPULAR",
    "NUTRIÇÃO",
    "OCEANOGRAFIA",
    "ODONTOLOGIA",
    "PEDAGOGIA",
    "PSICOLOGIA",
    "QUÍMICA",
    "SAÚDE COLETIVA",
    "SECRETARIADO EXECUTIVO",
    "SEGURANÇA PÚBLICA",
    "SERVIÇO SOCIAL",
    "SISTEMAS DE INFORMAÇÃO",
    "TEATRO",
    "TERAPIA OCUPACIONAL",
    "ZOOTECNIA"
  ];

  @override
  void initState() {
    super.initState();
    loadProfile(); 
  }

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(user.uid);

      final DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          profilePhoto = user.photoURL ?? profilePhoto;
          selectedCourse = data['course'] ?? '';
          shiftController.text = data['shift'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
            Text(
              'Olá, ${user?.displayName ?? 'Usuário'}!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCourse,
              items: courses
                  .map((course) =>
                      DropdownMenuItem(value: course, child: Text(course)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Curso'),
            ),
            TextField(
              controller: shiftController,
              decoration: const InputDecoration(labelText: 'Turno'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (user != null) {
                  final DatabaseReference userRef =
                      FirebaseDatabase.instance.ref().child('users').child(user.uid);

                  await userRef.set({
                    'name': user.displayName,
                    'course': selectedCourse,
                    'shift': shiftController.text,
                    'photo': profilePhoto,
                    'email': user.email,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil atualizado com sucesso!')),
                  );
                }
              },
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}

class RideOfferPage extends StatefulWidget {
  const RideOfferPage({super.key});

  @override
  _RideOfferPageState createState() => _RideOfferPageState();
}

class _RideOfferPageState extends State<RideOfferPage> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController stopsController = TextEditingController();
  final TextEditingController departureLocationController = TextEditingController(); 
  final TextEditingController departureTimeController = TextEditingController();

  List<Map<String, String>> cars = [];
  String? selectedCar;
  String? selectedSeats;

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      final DataSnapshot snapshot = await carsRef.get();

      if (snapshot.exists) {
        final loadedCars = (snapshot.value as Map).entries.map((entry) {
          final car = Map<String, String>.from(entry.value as Map);
          car['key'] = entry.key;
          return car;
        }).toList();

        setState(() {
          cars = loadedCars;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oferecer Carona')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCar,
              items: cars.map((car) {
                return DropdownMenuItem<String>(
                  value: car['key'],
                  child: Text('${car['name']} (${car['plate']})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCar = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Selecionar Automóvel'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: departureLocationController,
              decoration: const InputDecoration(labelText: 'Local de Saída'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: departureTimeController,
              decoration: const InputDecoration(labelText: 'Horário de Saída'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: destinationController,
              decoration: const InputDecoration(labelText: 'Destino'),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedSeats,
              items: List.generate(7, (index) {
                return DropdownMenuItem(
                  value: (index + 1).toString(),
                  child: Text('${index + 1} vagas'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedSeats = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Vagas Disponíveis'),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: stopsController,
              decoration: const InputDecoration(labelText: 'Pontos de Parada'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                if (user != null && selectedCar != null && selectedSeats != null) {
                  final DatabaseReference ridesRef =
                      FirebaseDatabase.instance.ref().child('rides').child(user.uid);

                      final DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats');

                   final rideKey = ridesRef.push().key;
                  await ridesRef.child(rideKey!).set({
                    'carKey': selectedCar,
                    'departureLocation': departureLocationController.text, 
                    'departureTime': departureTimeController.text, 
                    'destination': destinationController.text,
                    'seats': selectedSeats,
                    'stops': stopsController.text,
                    'timestamp': DateTime.now().toIso8601String(),
                    'chatId': rideKey,
                  });

                  // Criar o chat associado à carona
    await chatRef.child(rideKey).set({
      'rideId': rideKey,
      'messages': {}, // Inicializa a lista de mensagens vazia
    });


                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Carona oferecida com sucesso!')),
                  );

                  setState(() {
                    departureLocationController.clear();
                    departureTimeController.clear();
                    destinationController.clear();
                    stopsController.clear();
                    selectedCar = null;
                    selectedSeats = null;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, preencha todos os campos.')),
                  );
                }
              },
              child: const Text('Oferecer Carona'),
            ),
          ],
        ),
      ),
    );
  }
}


class RideListPage extends StatefulWidget {
  const RideListPage({super.key});

  @override
  _RideListPageState createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  List<Map<String, dynamic>> rides = [];
  final User? currentUser = FirebaseAuth.instance.currentUser; 

  @override
  void initState() {
    super.initState();
    loadRides();
  }

  Future<void> loadRides() async {
  final DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child('rides');
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

  final DataSnapshot ridesSnapshot = await ridesRef.get();

  if (ridesSnapshot.exists) {
    final Map<dynamic, dynamic> ridesMap = ridesSnapshot.value as Map<dynamic, dynamic>;
    final List<Map<String, dynamic>> loadedRides = [];

    for (var userId in ridesMap.keys) {
      final userRides = ridesMap[userId];
      if (userRides != null) {
        final Map<dynamic, dynamic> userRidesMap = userRides as Map<dynamic, dynamic>;

        final DataSnapshot userSnapshot = await usersRef.child(userId).get();
        final String userName = userSnapshot.child('name').value as String? ?? 'Usuário Desconhecido';

        for (var rideId in userRidesMap.keys) {
          final rideData = userRidesMap[rideId];
          loadedRides.add({
            'userId': userId,
            'rideId': rideId,
            'userName': userName,
            ...Map<String, dynamic>.from(rideData as Map),
          });
        }
      }
    }

    setState(() {
      rides = loadedRides;
    });
  }
}

Future<void> acceptRide(Map<String, dynamic> ride) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final DatabaseReference rideRef = FirebaseDatabase.instance
        .ref()
        .child('rides')
        .child(ride['userId'])
        .child(ride['rideId']);

    final DataSnapshot rideSnapshot = await rideRef.get();

    if (rideSnapshot.exists) {
      final Map<String, dynamic> rideData = Map<String, dynamic>.from(rideSnapshot.value as Map);
      int availableSeats = int.tryParse(rideData['seats'] ?? '0') ?? 0;

      if (availableSeats > 0) {
        // Reduzir o número de vagas disponíveis
        availableSeats -= 1;

        // Atualizar o número de vagas no banco de dados
        await rideRef.update({
          'seats': availableSeats.toString(),
          'acceptedBy': user.uid, // Armazenar o ID do usuário que aceitou a carona
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Você aceitou a carona para ${ride['destination']}')),
        );

        // Recarregar a lista de caronas para refletir as mudanças
        loadRides();
      } else {
        // Se não houver mais vagas, informar o usuário
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não há mais vagas disponíveis para esta carona.')),
        );
      }
    }
  }
}

Future<void> cancelAcceptedRide(Map<String, dynamic> ride) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final DatabaseReference rideRef = FirebaseDatabase.instance
        .ref()
        .child('rides')
        .child(ride['userId'])
        .child(ride['rideId']);

    final DataSnapshot rideSnapshot = await rideRef.get();

    if (rideSnapshot.exists) {
      final Map<String, dynamic> rideData = Map<String, dynamic>.from(rideSnapshot.value as Map);
      int availableSeats = int.tryParse(rideData['seats'] ?? '0') ?? 0;

      // Incrementar o número de vagas disponíveis
      availableSeats += 1;

      // Atualizar o número de vagas no banco de dados e remover o ID do usuário que aceitou a carona
      await rideRef.update({
        'seats': availableSeats.toString(),
        'acceptedBy': null, // Remover o ID do usuário que aceitou a carona
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você cancelou a carona para ${ride['destination']}')),
      );

      // Recarregar a lista de caronas para refletir as mudanças
      loadRides();
    }
  }
}

  Future<void> cancelRide(Map<String, dynamic> ride) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && ride['userId'] == user.uid) {
      final DatabaseReference ridesRef = FirebaseDatabase.instance.ref().child('rides');
      final DatabaseReference historyRef = FirebaseDatabase.instance.ref().child('history');

      await historyRef.child(ride['userId']).child(ride['rideId']).set({
        ...ride,
        'status': 'canceled', 
      });

      await ridesRef.child(ride['userId']).child(ride['rideId']).remove();

      setState(() {
        rides.removeWhere((r) => r['rideId'] == ride['rideId']);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Carona para ${ride['destination']} cancelada com sucesso!')),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Caronas Disponíveis')),
    body: ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        final isCurrentUserRide = ride['userId'] == currentUser?.uid;
        final availableSeats = int.tryParse(ride['seats'] ?? '0') ?? 0;
        final isRideFull = availableSeats <= 0;
        final isRideAcceptedByCurrentUser = ride['acceptedBy'] == currentUser?.uid;

        return ListTile(
          title: Text('Destino: ${ride['destination']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Local de Saída: ${ride['departureLocation']}'),
              Text('Horário de Saída: ${ride['departureTime']}'),
              Text('Vagas: ${ride['seats']}'),
              Text('Paradas: ${ride['stops']}'),
              Text('Oferecido por: ${ride['userName']}'),
              if (isRideFull)
                const Text(
                  'Não há mais vagas disponíveis.',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCurrentUserRide && !isRideFull && !isRideAcceptedByCurrentUser)
                ElevatedButton(
                  onPressed: () => acceptRide(ride),
                  child: const Text('Aceitar Carona'),
                ),
              if (isRideAcceptedByCurrentUser)
                ElevatedButton(
                  onPressed: () => cancelAcceptedRide(ride),
                  child: const Text('Cancelar Carona'),
                ),
              IconButton(
                icon: const Icon(Icons.chat),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(rideId: ride['rideId']),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    ),
  );
}

}

class ChatScreen extends StatefulWidget {
  final String rideId;

  const ChatScreen({super.key, required this.rideId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final DatabaseReference chatRef =
        FirebaseDatabase.instance.ref().child('chats').child(widget.rideId).child('messages');

    chatRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        final Map<dynamic, dynamic> messagesMap = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          messages = messagesMap.entries.map((entry) {
            return {
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value as Map),
            };
          }).toList();
        });
      }
    });
  }

  Future<void> sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && messageController.text.isNotEmpty) {
      final DatabaseReference chatRef =
          FirebaseDatabase.instance.ref().child('chats').child(widget.rideId).child('messages');

      await chatRef.push().set({
        'senderId': user.uid,
        'senderName': user.displayName,
        'message': messageController.text,
        'timestamp': DateTime.now().toIso8601String(),
      });

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat da Carona'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['senderName'] ?? 'Usuário Desconhecido'),
                  subtitle: Text(message['message']),
                  trailing: Text(
                    DateTime.parse(message['timestamp']).toLocal().toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RideHistoryPage extends StatefulWidget {
  const RideHistoryPage({super.key});

  @override
  _RideHistoryPageState createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  List<Map<String, dynamic>> historyRides = [];
  final User? currentUser = FirebaseAuth.instance.currentUser; 

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    if (currentUser != null) {
      final DatabaseReference historyRef =
          FirebaseDatabase.instance.ref().child('history').child(currentUser!.uid);

      final DataSnapshot historySnapshot = await historyRef.get();

      if (historySnapshot.exists) {
        final Map<dynamic, dynamic> historyMap =
            historySnapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> loadedHistory = historyMap.entries.map((entry) {
          return {
            'rideId': entry.key,
            ...Map<String, dynamic>.from(entry.value as Map),
          };
        }).toList();

        setState(() {
          historyRides = loadedHistory;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Caronas')),
      body: historyRides.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma carona no histórico.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: historyRides.length,
              itemBuilder: (context, index) {
                final ride = historyRides[index];
                return ListTile(
                  title: Text('Destino: ${ride['destination']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Vagas: ${ride['seats']}'),
                      Text('Paradas: ${ride['stops']}'),
                      Text('Status: ${ride['status']}'),
                    ],
                  ),
                );
              },
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

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      final DataSnapshot snapshot = await carsRef.get();

      if (snapshot.exists) {
        final List<Map<String, String>> loadedCars = (snapshot.value as Map).values.map((car) {
          return Map<String, String>.from(car as Map);
        }).toList();

        setState(() {
          cars.clear();
          cars.addAll(loadedCars);
        });
      }
    }
  }

  void addCar() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      final carData = {
        'plate': plateController.text,
        'name': nameController.text,
        'color': colorController.text,
      };

      await carsRef.push().set(carData);

      setState(() {
        cars.add(carData);
        plateController.clear();
        nameController.clear();
        colorController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Automóvel adicionado com sucesso!')),
      );
    }
  }

  void removeCar(int index) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final DatabaseReference carsRef =
          FirebaseDatabase.instance.ref().child('cars').child(user.uid);

      final carKey = cars[index]['key'];
      if (carKey != null) {
        await carsRef.child(carKey).remove();

        setState(() {
          cars.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Automóvel removido com sucesso!')),
        );
      }
    }
  }

  void editCar(int index) {
    plateController.text = cars[index]['plate'] ?? '';
    nameController.text = cars[index]['name'] ?? '';
    colorController.text = cars[index]['color'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Automóvel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: plateController, decoration: const InputDecoration(labelText: 'Placa')),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Cor')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                final DatabaseReference carsRef =
                    FirebaseDatabase.instance.ref().child('cars').child(user.uid);

                final carKey = cars[index]['key'];
                if (carKey != null) {
                  await carsRef.child(carKey).update({
                    'plate': plateController.text,
                    'name': nameController.text,
                    'color': colorController.text,
                  });

                  setState(() {
                    cars[index] = {
                      'plate': plateController.text,
                      'name': nameController.text,
                      'color': colorController.text,
                    };
                  });
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Automóvel atualizado com sucesso!')),
                );
              }
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(cars[index]['name'] ?? ''),
                    subtitle: Text('Placa: ${cars[index]['plate']}, Cor: ${cars[index]['color']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editCar(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeCar(index),
                        ),
                      ],
                    ),
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
