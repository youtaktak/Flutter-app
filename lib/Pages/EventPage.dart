import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import de la bibliothèque intl

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
            List<Widget> eventWidgets = [];
            snapshot.data!.docs.forEach((element) {
              // Récupérer toutes les données du document de manière dynamique
              Map<String, dynamic> event = element.data() as Map<String, dynamic>;

              // Récupérer le speaker et le sujet
              String speaker = event['speaker'] ?? 'Speaker inconnu';
              String sujet = event['sujet'] ?? 'Sujet non défini';

              // Construire la liste d'éléments pour chaque événement avec speaker en titre et sujet en sous-titre
              eventWidgets.add(
                ListTile(
                  title: Text(speaker, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sujet, style: TextStyle(color: Colors.blueGrey)),
                      ...event.entries.map((entry) {
                        // Afficher toutes les autres clés et valeurs sauf 'speaker' et 'sujet'
                        if (entry.key != 'speaker' && entry.key != 'sujet') {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: TextStyle(fontWeight: FontWeight.bold), // Clé en gras
                                ),
                                Expanded( // Utilisation de Expanded pour éviter l'overflow
                                  child: Text('${entry.value}', overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(); // Ne rien afficher pour 'speaker' et 'sujet' ici
                      }).toList(),
                    ],
                  ),
                ),
              );
            });

            return ListView(
              children: eventWidgets,
            );
          },
        ),
      ),
    );
  }
}
