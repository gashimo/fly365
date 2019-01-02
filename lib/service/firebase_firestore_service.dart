import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fly365/model/Flight.dart';

final CollectionReference flightCollection = Firestore.instance.collection('flights');

class FirebaseFirestoreService {

  static final FirebaseFirestoreService _instance = new FirebaseFirestoreService.internal();

  factory FirebaseFirestoreService() => _instance;

  FirebaseFirestoreService.internal();

  Future<Flight> createFlight(String flightNumber, String airport, String dateTime, List<Map<String, String>> seats ) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(flightCollection.document());

      final Flight flight = new Flight(ds.documentID, airport, dateTime, seats);
      final Map<String, dynamic> data = flight.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Flight.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getFlightsList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = flightCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }

    if (limit != null) {
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Stream<DocumentSnapshot> getSeatsList({String flightNumber}) {
    Stream<DocumentSnapshot> snapshots = flightCollection.document(flightNumber).snapshots();

    return snapshots;
  }

  Future<dynamic> updateFlight(Flight flight) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(flightCollection.document(flight.number));

      await tx.update(ds.reference, flight.toMap());
      return {'updated': true};
    };

    return Firestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Future<dynamic> deleteFlight(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(flightCollection.document(id));

      await tx.delete(ds.reference);
      return {'deleted': true};
    };

    return Firestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}