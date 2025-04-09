import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    Future<void> showEventDetailsDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Conférence Lior'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Image.asset("assets/images/venice.jpg",height:120),
                  const Text('titre: sujet de la conf'),
                  const Text('speaker: lior chamla'),
                  const Text('date de la conf:'),

                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton.icon(
                  onPressed: (){},
                  icon: Icon(Icons.calendar_month),
                  label:  Text("ajouter au calendrier")),
              TextButton(
                child: const Text('Fermer'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
                  trailing: IconButton(
                    icon: Icon(Icons.info),
                    onPressed:(){showEventDetailsDialog();}
                  ),
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
