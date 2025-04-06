import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Pour formater les dates

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning des événements'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Events").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("Aucune conférence");
            }

            // Liste des widgets pour afficher chaque événement
            List<Widget> eventWidgets = snapshot.data!.docs.map((element) {
              Map<String, dynamic> event = element.data() as Map<String, dynamic>;

              String speaker = event['speaker'] ?? 'Speaker inconnu';
              String sujet = event['sujet'] ?? 'Sujet non défini';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    speaker,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sujet,
                        style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ...event.entries.map((entry) {
                        if (entry.key != 'speaker' && entry.key != 'sujet') {
                          // Formater proprement la date si c’est un Timestamp
                          String valueToShow;
                          if (entry.value is Timestamp) {
                            DateTime date = (entry.value as Timestamp).toDate();
                            valueToShow = DateFormat('dd MMMM yyyy – HH:mm').format(date);
                          } else {
                            valueToShow = entry.value.toString();
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${entry.key} : ",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(valueToShow),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: eventWidgets,
            );
          },
        ),
      ),
    );
  }
}
