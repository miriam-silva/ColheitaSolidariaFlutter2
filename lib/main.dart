import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import das suas páginas
import 'views/Home/home_page.dart';
import 'views/Home/Login/login_page.dart';
import 'views/Home/Cadastro/cadastro_page.dart';
import 'views/Administrador/administrador_page.dart';
import 'views/Recebedor/recebedor_page.dart';
import 'views/Colaborador/colaborador_page.dart';
import 'views/Home/sobrenos_page.dart';
import 'views/Home/colaboradores_page.dart';
import 'views/Home/comoajudar_page.dart';
import 'views/Home/contato_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colheita Solidária',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      initialRoute: '/home',

      routes: {
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdministradorPage(),
        '/recebedor': (context) => const RecebedorPage(),
        '/colaborador': (context) => const ColaboradorPage(),
        '/sobrenos': (context) => const SobrePage(),
        '/colaboradores': (context) => const ColaboradoresPage(),
        '/comoajudar': (context) => const ComoAjudarPage(),
        '/contato': (context) => const ContatoPage(),
      },
    );
  }
}