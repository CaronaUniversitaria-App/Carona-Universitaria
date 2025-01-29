import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../repositories/car_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  final CarRepository _carRepository = CarRepository();
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
    final user = _authController.getCurrentUser();
    if (user != null) {
      setState(() {
        profilePhoto = user.photoURL ?? profilePhoto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.getCurrentUser();

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
                  await _carRepository.addCar(user.uid, {
                    'course': selectedCourse,
                    'shift': shiftController.text,
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