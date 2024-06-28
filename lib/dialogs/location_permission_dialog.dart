import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionDialog extends StatelessWidget {
  final Widget defaultHome;

  const LocationPermissionDialog({super.key, required this.defaultHome});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/ic_launcher.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Foodly App',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Foodly App necesita acceder a tu ubicación para poder mostrar los pedidos y entregas en tiempo real, así como para calcular distancias y costos, incluso cuando la aplicación está cerrada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    final permissionStatus = await Permission.locationWhenInUse.request();
                    if (permissionStatus.isGranted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => defaultHome),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Permitir',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(fontSize: 16),
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
