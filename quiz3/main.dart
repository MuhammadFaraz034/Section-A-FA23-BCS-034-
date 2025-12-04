import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const NewBMICalculator());
}

class NewBMICalculator extends StatelessWidget {
  const NewBMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController heightC = TextEditingController();
  TextEditingController weightC = TextEditingController();

  double bmi = 0;
  String category = "";

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  void calculate() {
    double h = double.tryParse(heightC.text) ?? 0;
    double w = double.tryParse(weightC.text) ?? 0;

    if (h > 0 && w > 0) {
      double meter = h / 100;
      double result = w / pow(meter, 2);

      String cat;
      if (result < 18.5) {
        cat = "Underweight";
      } else if (result < 24.9) {
        cat = "Normal";
      } else if (result < 29.9) {
        cat = "Overweight";
      } else {
        cat = "Obese";
      }

      setState(() {
        bmi = result;
        category = cat;
      });

      controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW BACKGROUND GRADIENT
      body: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF654ea3), Color(0xFFeaafc8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // TITLE
                Text(
                  "BMI CHECKER",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // NEW GLASS CARD
                Container(
                  padding: EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      buildField(heightC, "Height in cm", Icons.height),
                      SizedBox(height: 20),
                      buildField(weightC, "Weight in kg", Icons.monitor_weight),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // NEON BUTTON
                GestureDetector(
                  onTap: calculate,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFff9a9e),
                          Color(0xFFf6416c),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "CALCULATE",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // RESULT WITH ANIMATION
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: animation.value,
                      child: Opacity(
                        opacity: animation.value,
                        child: bmi == 0
                            ? SizedBox()
                            : Column(
                          children: [
                            // RESULT CARD
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                Border.all(color: Colors.white30),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    bmi.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController c, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(18),
        ),
      ),
    );
  }
}
