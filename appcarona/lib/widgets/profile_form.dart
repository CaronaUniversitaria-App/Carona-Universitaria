import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
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
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView( // Adicionando rolagem
      child: Column(
        mainAxisSize: MainAxisSize.min, // Garante que a Column se ajuste ao conteúdo
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
                final DatabaseReference userRef = FirebaseDatabase.instance
                    .ref()
                    .child('users')
                    .child(user.uid);

                await userRef.set({
                  'name': user.displayName,
                  'course': selectedCourse,
                  'shift': shiftController.text,
                  'photo': profilePhoto,
                  'email': user.email,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Perfil atualizado com sucesso!')),
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
