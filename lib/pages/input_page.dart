// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Anak-anak',
    'Remaja',
    'Dewasa',
  ];

  String _selectedGender = 'Laki-laki';

  void resetForm() {
    _nameController.clear();
    _weightController.clear();
    _heightController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedGender = 'Laki-laki';
    });
  }

  InputDecoration fieldDecoration({
    required String label,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixText: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F7FB),

      appBar: AppBar(
        title: Text(
          "Kalkulator BMI",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 1000,
            ),

            child: Column(
              children: [
                // HEADER
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.lightBlueAccent,
                      ],
                    ),

                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: Column(
                    children: [
                      Icon(
                        Icons.monitor_weight,
                        size: 70,
                        color: Colors.white,
                      ),

                      SizedBox(height: 10),

                      Text(
                        "Cek BMI Kamu",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Isi data untuk mengetahui BMI kamu",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22),

                // FORM
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,

                    child: Column(
                      children: [
                        // NAMA
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(18),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue
                                    .withOpacity(0.08),
                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child: TextFormField(
                            controller: _nameController,

                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Mohon isi nama';
                              }
                              return null;
                            },

                            decoration: fieldDecoration(
                              label: 'Nama Lengkap',
                              icon: Icons.person,
                            ).copyWith(
                              hintText:
                                  "Masukkan nama kamu",
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // BERAT & TINGGI
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                        18,
                                      ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(
                                            0.05,
                                          ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),

                                child: TextFormField(
                                  controller:
                                      _weightController,

                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),

                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d*'),
                                    ),
                                  ],

                                  validator: (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .isEmpty) {
                                      return 'Mohon isi berat badan';
                                    }
                                    return null;
                                  },

                                  decoration:
                                      fieldDecoration(
                                        label:
                                            'Berat',
                                        icon:
                                            Icons
                                                .scale,
                                        suffix:
                                            'kg',
                                      ),
                                ),
                              ),
                            ),

                            SizedBox(width: 14),

                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                        18,
                                      ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(
                                            0.05,
                                          ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),

                                child: TextFormField(
                                  controller:
                                      _heightController,

                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),

                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d*'),
                                    ),
                                  ],

                                  validator: (value) {
                                    if (value ==
                                            null ||
                                        value
                                            .isEmpty) {
                                      return 'Mohon isi tinggi badan';
                                    }
                                    return null;
                                  },

                                  decoration:
                                      fieldDecoration(
                                        label:
                                            'Tinggi',
                                        icon:
                                            Icons
                                                .height,
                                        suffix:
                                            'cm',
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // KATEGORI
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(18),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),

                          child:
                              DropdownButtonFormField<
                                String
                              >(
                                value:
                                    _selectedCategory,

                                validator: (
                                  value,
                                ) {
                                  if (value ==
                                          null ||
                                      value
                                          .isEmpty) {
                                    return 'Pilih kategori usia';
                                  }
                                  return null;
                                },

                                decoration:
                                    fieldDecoration(
                                      label:
                                          'Kategori Usia',
                                      icon:
                                          Icons
                                              .category,
                                    ),

                                hint: Text(
                                  'Pilih kategori...',
                                ),

                                items:
                                    _categories.map((
                                      category,
                                    ) {
                                      return DropdownMenuItem(
                                        value:
                                            category,
                                        child:
                                            Text(
                                              category,
                                            ),
                                      );
                                    }).toList(),

                                onChanged: (
                                  value,
                                ) {
                                  setState(() {
                                    _selectedCategory =
                                        value;
                                  });
                                },
                              ),
                        ),

                        SizedBox(height: 24),

                        // GENDER
                        Align(
                          alignment:
                              Alignment.centerLeft,

                          child: Text(
                            "Jenis Kelamin",

                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedGender =
                                        'Laki-laki';
                                  });
                                },

                                child:
                                    AnimatedContainer(
                                      duration:
                                          Duration(
                                            milliseconds:
                                                200,
                                          ),

                                      padding:
                                          EdgeInsets.symmetric(
                                            vertical:
                                                16,
                                          ),

                                      decoration:
                                          BoxDecoration(
                                            color:
                                                _selectedGender ==
                                                    'Laki-laki'
                                                ? Colors
                                                      .blue
                                                : Colors
                                                      .white,

                                            borderRadius:
                                                BorderRadius.circular(
                                                  18,
                                                ),

                                            border:
                                                Border.all(
                                                  color:
                                                      Colors.blue,
                                                  width:
                                                      1.5,
                                                ),

                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.black12,
                                                blurRadius:
                                                    6,
                                              ),
                                            ],
                                          ),

                                      child:
                                          Column(
                                            children: [
                                              Icon(
                                                Icons
                                                    .male,

                                                size:
                                                    28,

                                                color:
                                                    _selectedGender ==
                                                        'Laki-laki'
                                                    ? Colors.white
                                                    : Colors.blue,
                                              ),

                                              SizedBox(
                                                height:
                                                    6,
                                              ),

                                              Text(
                                                "Laki-laki",

                                                style: TextStyle(
                                                  color:
                                                      _selectedGender == 'Laki-laki'
                                                      ? Colors.white
                                                      : Colors.blue,

                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                              ),
                            ),

                            SizedBox(width: 14),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedGender =
                                        'Perempuan';
                                  });
                                },

                                child:
                                    AnimatedContainer(
                                      duration:
                                          Duration(
                                            milliseconds:
                                                200,
                                          ),

                                      padding:
                                          EdgeInsets.symmetric(
                                            vertical:
                                                16,
                                          ),

                                      decoration:
                                          BoxDecoration(
                                            color:
                                                _selectedGender ==
                                                    'Perempuan'
                                                ? Colors
                                                      .pink
                                                : Colors
                                                      .white,

                                            borderRadius:
                                                BorderRadius.circular(
                                                  18,
                                                ),

                                            border:
                                                Border.all(
                                                  color:
                                                      Colors.pink,
                                                  width:
                                                      1.5,
                                                ),

                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.black12,
                                                blurRadius:
                                                    6,
                                              ),
                                            ],
                                          ),

                                      child:
                                          Column(
                                            children: [
                                              Icon(
                                                Icons
                                                    .female,

                                                size:
                                                    28,

                                                color:
                                                    _selectedGender ==
                                                        'Perempuan'
                                                    ? Colors.white
                                                    : Colors.pink,
                                              ),

                                              SizedBox(
                                                height:
                                                    6,
                                              ),

                                              Text(
                                                "Perempuan",

                                                style: TextStyle(
                                                  color:
                                                      _selectedGender == 'Perempuan'
                                                      ? Colors.white
                                                      : Colors.pink,

                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                    ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 28),

                        // BUTTON HITUNG
                        SizedBox(
                          width: double.infinity,

                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue,
                              foregroundColor:
                                  Colors.white,

                              padding:
                                  EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      14,
                                    ),
                              ),
                            ),

                            onPressed: () {
                              if (_formKey.currentState!
                                  .validate()) {
                                final nama =
                                    _nameController
                                        .text;

                                final berat = double.parse(
                                  _weightController.text.replaceAll(',', '.'),
                                );

                                final tinggi = double.parse(
                                  _heightController.text.replaceAll(',', '.'),
                                ) / 100;

                                final bmi =
                                    berat /
                                    (tinggi *
                                        tinggi);

                                Navigator.push(
                                  context,

                                  MaterialPageRoute(
                                    builder:
                                        (
                                          context,
                                        ) => ResultPage(
                                          nama:
                                              nama,
                                          bmi:
                                              bmi,
                                          gender:
                                              _selectedGender,
                                          kategori:
                                              _selectedCategory!,
                                        ),
                                  ),
                                );
                              }
                            },

                            icon: Icon(
                              Icons.calculate,
                            ),

                            label: Text(
                              "Hitung BMI",

                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        TextButton.icon(
                          onPressed: resetForm,
                          icon: Icon(Icons.refresh),
                          label: Text("Reset"),
                        ),
                      ],
                    ),
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