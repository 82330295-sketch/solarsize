/*
SolarSize - CSCI410 Project 1
Application to estimate the solar system a home needs.
The user selects the home appliances, the quantity and hours per day of each one,
the sun hours in the area and the battery backup hours needed at night.
The application then calculates the number of solar panels, the number of
batteries, the inverter size (kVA) and an estimated cost.
 */
import 'package:flutter/material.dart';

import 'home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SolarSize',
      theme: ThemeData(colorSchemeSeed: const Color(0xFFF5A524)),
      home: const Home(), // calls the main page to display the application interface
    );
  }
}
