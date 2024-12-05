import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponto/services/firestore.dart';

class AnalisePage extends StatefulWidget {
  const AnalisePage({super.key});

  @override
  State<AnalisePage> createState() => _AnalisePageState();
}

class _AnalisePageState extends State<AnalisePage> {
  final FirestoreService firestoreService = FirestoreService();
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> analysisResults = [];
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  String? selectedGeofence;
  String? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Análise de Tempo por Funcionário"),
        backgroundColor: const Color.fromARGB(255, 103, 58, 183),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Filtrar por Data',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 103, 58, 183),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDatePickerField('Data de Início', startDate, (pickedDate) {
                    setState(() => startDate = pickedDate);
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePickerField('Data de Fim', endDate, (pickedDate) {
                    setState(() => endDate = pickedDate);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    'Geofence',
                    _getGeofences,
                    selectedGeofence,
                    (value) {
                      if (value == 'Selecionar todos') {
                        setState(() => selectedGeofence = null);
                      } else {
                        setState(() => selectedGeofence = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Funcionário',
                    _getEmployees,
                    selectedEmployee,
                    (value) {
                      if (value == 'Selecionar todos') {
                        setState(() => selectedEmployee = null);
                      } else {
                        setState(() => selectedEmployee = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _filterData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 103, 58, 183),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Analisar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'Limpar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: analysisResults.isEmpty
                  ? const Center(child: Text("Nenhum resultado encontrado"))
                  : _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label, DateTime? date, ValueChanged<DateTime?> onDatePicked) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: date != null ? dateFormat.format(date) : '',
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != date) {
          onDatePicked(pickedDate);
        }
      },
    );
  }

  Widget _buildDropdown(String hint, Future<List<String>> Function() fetchItems, String? selectedValue, ValueChanged<String?> onChanged) {
    return FutureBuilder<List<String>>(
      future: fetchItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Erro ao carregar $hint: ${snapshot.error}');
        }
        final items = ['Selecionar todos', ...?snapshot.data];
        return DropdownButton<String>(
          value: selectedValue,
          hint: Text('Selecione $hint'),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        );
      },
    );
  }

  Future<List<String>> _getGeofences() async {
    QuerySnapshot snapshot = await firestoreService.geofenceRecords.get();
    return snapshot.docs.map((doc) => doc['geofence_name'] as String).toSet().toList();
  }

  Future<List<String>> _getEmployees() async {
    QuerySnapshot snapshot = await firestoreService.geofenceRecords.get();
    return snapshot.docs.map((doc) => doc['user_name'] as String).toSet().toList();
  }

  void _filterData() {
  if (startDate == null || endDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selecione as datas de início e fim')),
    );
    return;
  }

  final startTimestamp = startDate!.millisecondsSinceEpoch;
  final endTimestamp = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59).millisecondsSinceEpoch;

  // Inicia a consulta no Firestore
  Query query = firestoreService.geofenceRecords
      .where('timestamp', isGreaterThanOrEqualTo: startTimestamp)
      .where('timestamp', isLessThanOrEqualTo: endTimestamp)
      .orderBy('timestamp');

  // Adiciona filtro de Geofence se um valor for selecionado
  if (selectedGeofence != null) {
    query = query.where('geofence_name', isEqualTo: selectedGeofence);
  }

  // Adiciona filtro de Funcionário se um valor for selecionado
  if (selectedEmployee != null) {
    query = query.where('user_name', isEqualTo: selectedEmployee);
  }

  // Executa a consulta em tempo real
  query.snapshots().listen((snapshot) {
    Map<String, List<Map<String, dynamic>>> groupedResults = {};

    // Agrupando os dados por usuário e geofence
    snapshot.docs.forEach((doc) {
      final userName = doc['user_name'];
      final geofenceName = doc['geofence_name'];
      final timestamp = doc['timestamp'] as int;

      // Criar uma entrada para o usuário e a geofence se não existir
      if (!groupedResults.containsKey(userName)) {
        groupedResults[userName] = [];
      }

      groupedResults[userName]?.add({
        'geofence_name': geofenceName,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(timestamp),
        'event_type': doc['event_type'],
      });
    });

    List<Map<String, dynamic>> results = [];

    // Processando os eventos agrupados para calcular o tempo gasto
    groupedResults.forEach((userName, events) {
      DateTime? lastEntry;
      String? lastGeofence;
      for (var event in events) {
        if (event['event_type'] == 'Entrada Confirmada') {
          lastEntry = event['timestamp'];
          lastGeofence = event['geofence_name'];
        } else if (event['event_type'] == 'Saída Confirmada' && lastEntry != null && lastGeofence == event['geofence_name']) {
          final entryTime = lastEntry;
          final exitTime = event['timestamp'];

          // Calculando o tempo de permanência
          final duration = exitTime.difference(entryTime);
          final hours = duration.inHours;
          final minutes = duration.inMinutes % 60;

          results.add({
            'user_name': userName,
            'geofence_name': lastGeofence,
            'hours': hours,
            'minutes': minutes,
          });

          lastEntry = null;  // Resetando para o próximo par de entrada e saída
          lastGeofence = null;
        }
      }
    });

    setState(() {
      analysisResults = results;
    });
  });
}

  void _clearFilters() {
    setState(() {
      startDate = null;
      endDate = null;
      selectedGeofence = null;
      selectedEmployee = null;
      analysisResults.clear();
    });
  }

  Widget _buildResultsList() {
    return ListView.builder(
      itemCount: analysisResults.length,
      itemBuilder: (context, index) {
        final result = analysisResults[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('${result['user_name']} - ${result['geofence_name']}'),
            subtitle: Text(
              'Tempo gasto: ${result['hours']}h ${result['minutes']}min',
            ),
          ),
        );
      },
    );
  }
}
