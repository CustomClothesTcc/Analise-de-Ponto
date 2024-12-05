import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExibirCercasPage extends StatelessWidget {
  const ExibirCercasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cercas Cadastradas'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 103, 58, 183),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cercas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar dados.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma cerca cadastrada.'));
          }

          // Listagem das cercas
          final cercas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cercas.length,
            itemBuilder: (context, index) {
              final cerca = cercas[index];
              final nome = cerca['nome'];
              final latitude = cerca['latitude'];
              final longitude = cerca['longitude'];
              final raio = cerca['raio'];
              final docId = cerca.id;

              return Dismissible(
                key: Key(docId), 
                direction: DismissDirection.horizontal, 
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // Ação de excluir (deslizar para a direita)
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Excluir'),
                          content: const Text('Você tem certeza que deseja excluir esta cerca?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Excluir a cerca do Firestore
                                await FirebaseFirestore.instance.collection('cercas').doc(docId).delete();
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Excluir'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Ação de editar (deslizar para a esquerda)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarCercaPage(
                          cercaId: docId,
                          nome: nome,
                          latitude: latitude,
                          longitude: longitude,
                          raio: raio,
                        ),
                      ),
                    );
                    return false; 
                  }
                },
                background: Container(
                  color: Colors.red, 
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: const Color.fromARGB(255, 0, 132, 255), 
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.edit, color: Color.fromARGB(255, 103, 58, 183)),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      nome,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text('Latitude: $latitude, Longitude: $longitude, Raio: $raio metros'),
                    trailing: const Icon(Icons.location_on, color: Color.fromARGB(255, 103, 58, 183)),
                    onTap: () {
                      // Ação ao clicar na cerca, se necessário
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EditarCercaPage extends StatelessWidget {
  final String cercaId;
  final String nome;
  final String latitude;
  final String longitude;
  final int raio;

  const EditarCercaPage({
    Key? key,
    required this.cercaId,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.raio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nomeController = TextEditingController(text: nome);
    final latitudeController = TextEditingController(text: latitude);
    final longitudeController = TextEditingController(text: longitude);
    final raioController = TextEditingController(text: raio.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cerca'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 103, 58, 183),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da Cerca',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 103, 58, 183)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 103, 58, 183), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(
                labelText: 'Latitude',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 103, 58, 183)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 103, 58, 183), width: 2),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(
                labelText: 'Longitude',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 103, 58, 183)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 103, 58, 183), width: 2),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: raioController,
              decoration: InputDecoration(
                labelText: 'Raio (metros)',
                labelStyle: TextStyle(color: const Color.fromARGB(255, 103, 58, 183)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color.fromARGB(255, 103, 58, 183), width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Atualizar os dados no Firestore
                await FirebaseFirestore.instance.collection('cercas').doc(cercaId).update({
                  'nome': nomeController.text,
                  'latitude': latitudeController.text,
                  'longitude': longitudeController.text,
                  'raio': int.parse(raioController.text),
                });

                // Retornar para a página anterior
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Salvar Alterações', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
