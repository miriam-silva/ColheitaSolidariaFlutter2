import 'package:flutter/material.dart';

// Import das suas páginas
import 'pages/Home/home_page.dart';
import 'pages/Home/Login/Cadastro/login_page.dart';
import 'pages/Administrador/administrador_page.dart';
import 'pages/Recebedor/recebedor_page.dart';
import 'pages/Colaborador/colaborador_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colheita Solidária',
      debugShowCheckedModeBanner: false,

      // Tema básico
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      // Primeira tela do app
      initialRoute: '/login',

      // Rotas do app
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/admin': (context) => const AdministradorPage(),
        '/recebedor': (context) => const RecebedorPage(),
        '/colaborador': (context) => const ColaboradorPage(),
      },
    );
  }
}