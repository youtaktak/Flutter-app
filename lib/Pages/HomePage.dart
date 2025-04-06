import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'EventPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              "Mon application",
              style: TextStyle(
                fontSize: 42,
                fontFamily: 'Poppins',
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Bienvenue sur mon salon virtuel de l'application",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton.icon(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                  backgroundColor: MaterialStateProperty.all(Colors.lightBlue)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                );
              },
              label: const Text(
                "Afficher le menu",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              icon: const Icon(Icons.calendar_month, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
