import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para fechar o app de forma saudável
import 'package:intl/intl.dart';
import 'package:ponto/pages/CadastrarCercaPage.dart';
import 'package:ponto/pages/ExibirCercasPage.dart';
import 'package:ponto/pages/LoginPage.dart';
import 'package:ponto/pages/analisePage.dart';
import 'package:ponto/services/firestore.dart';

import 'CadastrarEmailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 103, 58, 183),
        title: const Text(
          "Análise de Ponto",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: _buildDrawer(context),
      body: _buildBody(mediaQuery),
    );
  }

  // Método para construir o Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 103, 58, 183),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Menu Principal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart,
            text: "Análise de Ponto",
            destination: const AnalisePage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.add_location,
            text: "Cadastrar Cerca",
            destination: const CadastrarCercaPage(),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.location_city,
            text: "Cercas Cadastradas",
            destination: const ExibirCercasPage(),
          ),
          _buildDrawerItem(
          context,
          icon: Icons.email,
          text: "Cadastrar E-mail",
          destination: const CadastrarEmailPage(),  // Adicionado o item de cadastro de e-mail
        ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Sair"),
            onTap: () => _showLogoutConfirmationDialog(),
          ),
        ],
      ),
    );
  }

  // Método para criar os itens do Drawer
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, Widget? destination}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }

Widget _buildBody(MediaQueryData mediaQuery) {
  return StreamBuilder<QuerySnapshot>(
    stream: firestoreService.getRecordsStream(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List recordsList = snapshot.data!.docs;
        bool isSmallScreen = mediaQuery.size.width < 600;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: isSmallScreen ? mediaQuery.size.width * 0.95 : mediaQuery.size.width * 0.8,
                child: DataTable(
                  columnSpacing: isSmallScreen ? 20 : 40,
                  headingRowColor: MaterialStateProperty.all(const Color.fromARGB(255, 103, 58, 183)),
                  columns: const [
                    DataColumn(label: Text('Evento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))),
                    DataColumn(label: Text('Local', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))),
                    DataColumn(label: Text('Usuário', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))),
                    DataColumn(label: Text('Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))),
                    DataColumn(label: Text('Horário', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))),
                  ],
                  rows: recordsList.map<DataRow>((document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                    String eventType = data['event_type'] ?? 'Sem tipo de evento';
                    String geofenceName = data['geofence_name'] ?? 'Sem nome de geofence';
                    String userName = data['user_name'] ?? 'Desconhecido';

                    // Verificar se o timestamp é um Timestamp ou um int (em milissegundos)
                    var timestamp = data['timestamp'];
                    String? formattedDate;
                    String? formattedTime;

                    if (timestamp is Timestamp) {
                      formattedDate = formatTimestamp(timestamp)['date'];
                      formattedTime = formatTimestamp(timestamp)['time'];
                    } else if (timestamp is int) {
                      // Se for um inteiro, usar diretamente os milissegundos
                      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                      formattedDate = DateFormat('dd/MM/yyyy').format(date);
                      formattedTime = DateFormat('HH:mm:ss').format(date);
                    }

                    return DataRow(
                      cells: [
                        DataCell(Text(eventType)),
                        DataCell(Text(geofenceName)),
                        DataCell(Text(userName)),
                        DataCell(Text(formattedDate ?? 'Data inválida')),
                        DataCell(Text(formattedTime ?? 'Hora inválida')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const Center(child: Text("Nenhum dado encontrado"));
      }
    },
  );
}

// Método para formatar o timestamp
Map<String, String> formatTimestamp(dynamic timestamp) {
  if (timestamp is int) {
    // Converte de milissegundos para DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    String formattedTime = DateFormat('HH:mm:ss').format(date);
    return {'date': formattedDate, 'time': formattedTime};
  } else if (timestamp is Timestamp) {
    // Se já for um Timestamp, converte para DateTime
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    String formattedTime = DateFormat('HH:mm:ss').format(date);
    return {'date': formattedDate, 'time': formattedTime};
  } else {
    // Caso o formato seja inválido
    return {'date': 'Formato inválido', 'time': 'Formato inválido'};
  }
}



Future<void> _showLogoutConfirmationDialog() async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirmação de Logout', style: TextStyle(color: const Color.fromARGB(255, 103, 58, 183))),
        content: Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
            },
            child: Text('Não'),
          ),
          TextButton(
            onPressed: _logout,
            child: Text('Sim'),
          ),
        ],
      );
    },
  );
}

Future<void> _logout() async {
  try {
    // Realizar o logout no Firebase Authentication
    await FirebaseAuth.instance.signOut();

    // Redirecionar para a página de login e limpar o histórico de navegação
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  } catch (e) {
    // Caso ocorra um erro, exibir uma mensagem
    print('Erro ao realizar logout: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao realizar logout. Tente novamente.')),
    );
  }
}
}