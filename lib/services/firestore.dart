import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference geofenceRecords = 
    FirebaseFirestore.instance.collection('geofence_records');

  // Função para obter o stream de registros
  Stream<QuerySnapshot> getRecordsStream() {
    final geofenceStream = geofenceRecords.orderBy('timestamp', descending: true).snapshots();
    return geofenceStream;
  }
}

class GeofenceCadastroService {
  final CollectionReference geofenceCadastro = 
    FirebaseFirestore.instance.collection('cadastro_geofence');

  // Função para obter o stream de geofences
  Stream<QuerySnapshot> getGeofenceStream() {
    final geofenceStream = geofenceCadastro.orderBy('id', descending: true).snapshots();
    return geofenceStream;
  }

  // Função para adicionar uma nova geofence
  Future<void> addGeofence(String id, String nome, double latitude, double longitude, int raio, String codigoObra) async {
    try {
      await geofenceCadastro.add({
        'id': id,
        'nome': nome,
        'latitude': latitude,
        'longitude': longitude,
        'raio': raio,
        'codigo_obra': codigoObra,
        'timestamp': FieldValue.serverTimestamp(), // Adiciona um timestamp automático
      });
    } catch (e) {
      print('Erro ao adicionar a geofence: $e');
    }
  }
}
