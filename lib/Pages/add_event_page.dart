import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();

  final confNameController = TextEditingController();
  final speakerNameController = TextEditingController();

  String? selectedConfType = 'talk';
  DateTime? selectedDate;

  @override
  void dispose() {
    confNameController.dispose();
    speakerNameController.dispose();
    super.dispose();
  }

  void onChanged(String? value) {
    setState(() {
      selectedConfType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un événement'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Champ nom conférence
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nom de la conférence',
                      hintText: 'Entrez le nom de la conférence',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tu dois compléter ce champ";
                      }
                      return null;
                    },
                    controller: confNameController,
                  ),
                ),

                // Champ speaker
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nom du speaker',
                      hintText: 'Entrez le nom du speaker',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tu dois compléter ce champ";
                      }
                      return null;
                    },
                    controller: speakerNameController,
                  ),
                ),

                // Dropdown pour type d’événement
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField<String>(
                    value: selectedConfType,
                    decoration: const InputDecoration(
                      labelText: 'Type d\'événement',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: onChanged,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez sélectionner un type d'événement";
                      }
                      return null;
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'talk',
                        child: Text("Talk Show"),
                      ),
                      DropdownMenuItem(
                        value: 'demo',
                        child: Text("Démonstration de code"),
                      ),
                      DropdownMenuItem(
                        value: 'partner',
                        child: Text("Partenaire"),
                      ),
                    ],
                  ),
                ),

                // Sélecteur de date
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: DateTimeFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date de la conférence',
                      border: OutlineInputBorder(),
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    initialPickerDateTime: DateTime.now().add(const Duration(days: 7)),
                    onChanged: (DateTime? value) {
                      selectedDate = value;
                    },
                  ),
                ),

                // Bouton envoyer
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());

                        // Affichage d'un message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours...")),
                        );

                        // Exemple : afficher les données dans la console
                        print('Nom conférence: ${confNameController.text}');
                        print('Speaker: ${speakerNameController.text}');
                        print('Type: $selectedConfType');
                        print('Date: $selectedDate');

                        CollectionReference eventsRef =FirebaseFirestore.instance.collection("Events");
                        eventsRef.add({
                          'speaker': speakerNameController.text,
                          'date': selectedDate?.toIso8601String(), // convertie en texte
                          'subject': confNameController.text,
                          'type': selectedConfType,
                          'avatar': 'lior' // tu peux changer ça pour un champ image plus tard
                        });

                      }
                    },
                    child: const Text("Envoyer"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
