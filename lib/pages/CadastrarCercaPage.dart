import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';

class CadastrarCercaPage extends StatefulWidget {
  const CadastrarCercaPage({super.key});

  @override
  _CadastrarCercaPageState createState() => _CadastrarCercaPageState();
}

class _CadastrarCercaPageState extends State<CadastrarCercaPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController coordenadaController = TextEditingController();
  final TextEditingController raioController = TextEditingController();

  Future<void> salvarDados() async {
    final nome = nomeController.text;
    final coordenadas = coordenadaController.text;
    final raio = raioController.text;

    if (nome.isEmpty || coordenadas.isEmpty || raio.isEmpty) {
      _showErrorDialog('Preencha todos os campos corretamente!');
      return;
    }

    List<String> coordenadasList = coordenadas.split(',');
    if (coordenadasList.length != 2) {
      _showErrorDialog('Formato de coordenadas inválido!');
      return;
    }

    try {
      final latitude = double.parse(coordenadasList[0].trim()).toStringAsFixed(7);
      final longitude = double.parse(coordenadasList[1].trim()).toStringAsFixed(7);
      final raioInt = int.parse(raio.trim());

      if (raioInt <= 0) {
        _showErrorDialog('O raio deve ser maior que zero!');
        return;
      }

      FirebaseFirestore.instance.collection('cercas').add({
        'nome': nome,
        'latitude': latitude,
        'longitude': longitude,
        'raio': raioInt,
      }).then((value) {
        _showSuccessDialog('Cerca salva com sucesso!');
        _limparCampos();  // Limpar os campos após sucesso
      }).catchError((error) {
        _showErrorDialog('Erro ao salvar: $error');
      });
    } catch (e) {
      _showErrorDialog('Erro de conversão: $e');
    }
  }

  Future<void> importarCercas() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final input = file.openRead();
      final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

      for (var row in fields) {
        if (row.length >= 4) {
          String nome = row[0].toString();
          String codigo = row[1].toString();
          String coordenadas = row[2].toString();
          String raio = row[3].toString();

          await salvarDadosImportados(nome, codigo, coordenadas, raio);
        }
      }

      _showSuccessDialog('Cercas importadas com sucesso!');
    } else {
      _showErrorDialog('Nenhum arquivo selecionado.');
    }
  }

  Future<void> salvarDadosImportados(String nome, String codigo, String coordenadas, String raio) async {
    List<String> coordenadasList = coordenadas.split(',');
    if (coordenadasList.length != 2) {
      return; // Ou trate o erro de forma adequada
    }

    try {
      final latitude = double.parse(coordenadasList[0].trim()).toStringAsFixed(7);
      final longitude = double.parse(coordenadasList[1].trim()).toStringAsFixed(7);
      final raioInt = int.parse(raio.trim());

      if (raioInt <= 0) {
        return; // Ou trate o erro de forma adequada
      }

      await FirebaseFirestore.instance.collection('cercas').add({
        'nome': nome,
        'codigo': codigo,
        'latitude': latitude,
        'longitude': longitude,
        'raio': raioInt,
      });
    } catch (e) {
      _showErrorDialog('Erro ao salvar a cerca: $e');
    }
  }

  void _limparCampos() {
    nomeController.clear();
    coordenadaController.clear();
    raioController.clear();
}

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Erro', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sucesso', style: TextStyle(color: Colors.green)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Cerca'),
        backgroundColor: const Color.fromARGB(255, 103, 58, 183),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: importarCercas,
            tooltip: 'Importar Cercas',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Campo Nome da Cerca
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Cerca',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 103, 58, 183)),
                  ),
                  prefixIcon: Icon(Icons.location_on, color: Color.fromARGB(255, 103, 58, 183)),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              
              // Campo Coordenadas
              TextField(
                controller: coordenadaController,
                decoration: const InputDecoration(
                  labelText: 'Coordenadas (Latitude, Longitude)',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 103, 58, 183)),
                  ),
                  prefixIcon: Icon(Icons.map, color: Color.fromARGB(255, 103, 58, 183)),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Campo Raio
              TextField(
                controller: raioController,
                decoration: const InputDecoration(
                  labelText: 'Raio da Cerca',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 103, 58, 183)),
                  ),
                  prefixIcon: Icon(Icons.radio_button_checked, color: Color.fromARGB(255, 103, 58, 183)),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Botão Salvar Cerca
              ElevatedButton(
                onPressed: salvarDados,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Salvar Cerca',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}