import 'package:flutt/Pages/EventPage.dart';
import 'package:flutt/Pages/add_event_page.dart';
import 'package:flutter/material.dart';
import 'Pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
            );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentindex=0;
  setCurrentIndex(int index){
    setState(() {
        _currentindex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("application"),
        ),
        body: [
          HomePage(),
          EventPage(),
          AddEventPage()
        ][_currentindex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentindex,
          onTap: (index)=>setCurrentIndex(index),
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.grey,
          iconSize: 32,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'ajout',
            ),
          ],
        ),
      ),
    );
  }
}
