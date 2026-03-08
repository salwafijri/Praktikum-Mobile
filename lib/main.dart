import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 56, 49, 55),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/profil.jpeg"),
              ),
              Text("Jaden Kanemoto", style: GoogleFonts.pacifico(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold
              )),
              Text("ANDROID DEVELOPER", style: GoogleFonts.sourceSans3(
                fontSize: 20,
                color: const Color.fromARGB(255, 196, 186, 186),
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
              )),
              SizedBox(
                height: 20,
                width: 150,
                child: Divider(
                  color: const Color.fromARGB(255, 196, 186, 186)
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.mail, color: const Color.fromARGB(255, 56, 49, 55),),
                    Text("jadenkanemoto@gmail.com",
                    style: GoogleFonts.sourceSans3(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 196, 186, 186),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: const Color.fromARGB(255, 56, 49, 55),),
                    Text("081234567890",
                    style: GoogleFonts.sourceSans3(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 196, 186, 186),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}