// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String nama;
  final double bmi;
  final String gender;
  final String kategori;

  const ResultPage({
    super.key,
    required this.nama,
    required this.bmi,
    required this.gender,
    required this.kategori,
  });

  String kategoriBMI() {
    if (bmi < 18.5) {
      return "Kamu KURUS";
    } else if (bmi < 25) {
      return "Kamu NORMAL";
    } else if (bmi < 30) {
      return "Kamu KELEBIHAN BERAT";
    } else {
      return "Kamu OBESITAS";
    }
  }

  Color bmiColor() {
    if (bmi < 18.5) {
      return Colors.orange;
    } else if (bmi < 25) {
      return Colors.green;
    } else if (bmi < 30) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FB),

      appBar: AppBar(
        title: Text(
          "Hasil BMI",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),

        child: Center(
          child: SizedBox(
            width: 450,

            child: Card(
              elevation: 6,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: EdgeInsets.all(24),

                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 80,
                      color: bmiColor(),
                    ),

                    SizedBox(height: 15),

                    Text(
                      "Halo, $nama 👋",
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      bmi.toStringAsFixed(1),

                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: bmiColor(),
                      ),
                    ),

                    Text(
                      kategoriBMI(),

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: bmiColor(),
                      ),
                    ),

                    SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: (bmi / 40).clamp(0.0, 1.0),
                      minHeight: 10,
                      color: bmiColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    SizedBox(height: 25),

                    infoTile(
                      Icons.person,
                      "Jenis Kelamin",
                      gender,
                    ),

                    SizedBox(height: 12),

                    infoTile(
                      Icons.category,
                      "Kategori Usia",
                      kategori,
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,

                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: Icon(Icons.arrow_back),

                        label: Text("Kembali"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.blue),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2),

                Text(value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}