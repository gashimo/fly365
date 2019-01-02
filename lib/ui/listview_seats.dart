import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fly365/service/firebase_firestore_service.dart';

import 'package:fly365/model/Flight.dart';
//import 'package:fly365/ui/flight_screen.dart';

class ListViewSeats extends StatefulWidget {
  @override
  _ListViewSeatsState createState() => new _ListViewSeatsState();
}

class _ListViewSeatsState extends State<ListViewSeats> {
  Flight flight ;
  List<String> items;
  FirebaseFirestoreService db = new FirebaseFirestoreService();

  StreamSubscription<DocumentSnapshot> seatsSub;

  @override
  void initState() {
    super.initState();

    items = new List();

    seatsSub?.cancel();
    seatsSub = db.getSeatsList().listen((DocumentSnapshot snapshot) {
      final Map<String, dynamic> seats = snapshot.data;

      setState(() {
        this.items = seats;
      });
    });
  }

  @override
  void dispose() {
    seatsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'grokonez Firestore Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('grokonez Firestore Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position]}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),

                      leading: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text(
                              '${position + 1}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deleteSeat(context,  position)),
                        ],
                      ),
//                      onTap: () => _navigateToNote(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewSeat(context),
        ),
      ),
    );
  }

  void _deleteSeat(BuildContext context, int position) async {
    db.deleteSeat(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }


  void _createNewSeat(BuildContext context) async {
/*    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note(null, '', ''))),
    );
*/  }
}