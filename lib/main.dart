import 'package:colheitasolidaria_flutter/views/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

/// CONTEXT
import 'widgets/Context/DoacoesContext.dart';

/// HOME
import 'views/Home/Home.dart';
import 'views/Home/Cadastro e Login/Login.dart';
import 'views/Home/Cadastro e Login/Cadastro.dart';
import 'views/Home/SobreNos.dart';
import 'views/Home/Colaborador.dart';
import 'views/Home/ComoAjudar.dart';
import 'views/Home/Contato.dart';

/// RECEBEDOR
import 'views/Recebedor/Recebedor.dart';

/// COLABORADOR
import 'views/Colaborador/InicialColab/InicialColab.dart';
import 'views/Colaborador/MinhasDoacoes/MinhasDoacoes.dart';
import 'views/Colaborador/RegistrarDoacao/RegistrarDoacao.dart';
import 'views/Colaborador/DoacaoRegistrada/DoacaoRegistrada.dart';

/// ADMIN
import 'views/Administrador/InicialAdm/InicialAdm.dart';
import 'views/Administrador/Doacoes/DoacoesAdm.dart';
import 'views/Administrador/CadastrarReceb/CadastrarRecebAdm.dart';
import 'views/Administrador/GerenciarUsuarios/GerenciarusuariosAdm.dart';
import 'views/Administrador/Painel/PainelMetricoAdm.dart';
import 'views/Administrador/Pedidos/PedidosAdm.dart';

/// DRAWER
import 'widgets/Header/Drawer/AtualizarFotoPerfil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://jdeivuuyeclualawjudt.supabase.co',
    anonKey: 'sb_publishable_vCQz8CHhxOFvNguQUz8XzA_VPxAWvhi',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => DoacoesContext(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colheita Solidária',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
       scaffoldBackgroundColor: Color(0xFFF9E1B2),
      ),
      

      initialRoute: '/home',

      routes: {

        /// HOME
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/sobrenos': (context) => const SobrePage(),
        '/colaboradores': (context) => const ColaboradoresPage(),
        '/comoajudar': (context) => const ComoAjudarPage(),
        '/contato': (context) => const ContatoPage(),
        '/atualizar-foto': (context) =>
            const AtualizarFotoPerfil(),

        /// ADMIN
        '/admin': (context) => const InicialAdministrador(),
        '/adm/pedidos': (context) => PedidosPage(),
        '/adm/doacoes': (context) => DoacoesPage(),
        '/adm/cadastrar': (context) =>
            CadastrarRecebedorAdmPage(),
        '/adm/usuarios': (context) =>
            GerenciarUsuariosPage(),
        '/adm/painel': (context) => PainelMetrico(),

        /// COLABORADOR
        '/colaborador': (context) => const InicialColaborador(),
        '/colaborador/Registrardoacao': (context) => const RegistrarDoacao(),
        '/colaborador/MinhasDoacoes': (context) => const MinhasDoacoes(),
        '/colaborador/DoacaoRegistrada': (context) => const DoacaoRegistrada(),

        /// RECEBEDOR
        '/recebedor': (context) =>
            const RecebedorPage(),
      },
    );
  }
}