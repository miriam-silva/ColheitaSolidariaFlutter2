import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Import das suas páginas
import 'views/Home/Home.dart';
import 'views/Home/Cadastro e Login/Login.dart';
import 'views/Home/Cadastro e Login/Cadastro.dart';
import 'views/Recebedor/Recebedor.dart';
import 'views/Colaborador/colaborador_page.dart';
import 'views/Home/SobreNos.dart';
import 'views/Home/Colaborador.dart';
import 'views/Home/ComoAjudar.dart';
import 'views/Home/Contato.dart';
import 'widgets/Header/Drawer/AtualizarFotoPerfil.dart';

// Import páginas Adm
import 'views/Administrador/InicialAdm/InicialAdm.dart';
import 'views/Administrador/Doacoes/DoacoesAdm.dart';
import 'views/Administrador/CadastrarReceb/CadastrarRecebAdm.dart';
import 'views/Administrador/GerenciarUsuarios/GerenciarusuariosAdm.dart';
import 'views/Administrador/Painel/PainelMetricoAdm.dart';
import 'views/Administrador/Pedidos/PedidosAdm.dart';

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
        '/sobrenos': (context) => const SobrePage(),
        '/colaboradores': (context) => const ColaboradoresPage(),
        '/comoajudar': (context) => const ComoAjudarPage(),
        '/contato': (context) => const ContatoPage(),
        "/atualizar-foto": (context) => const AtualizarFotoPerfil(),

        // Adm pages
        '/admin': (context) => const InicialAdministrador(),
        '/adm/pedidos': (context) => PedidosPage(),
        '/adm/doacoes': (context) => DoacoesPage(),
        '/adm/cadastrar': (context) => CadastrarRecebedorAdmPage(),
        '/adm/usuarios': (context) => GerenciarUsuariosPage(),
        'adm/painel' : (context) => PainelMetrico(),

        // Colab pages
        '/colaborador': (context) => const ColaboradorPage(),

        // Receb pages:
        '/recebedor': (context) => const RecebedorPage(),

      },
    );
  }
}