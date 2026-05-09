import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conduite/providers/robot_controller.dart';
import 'package:conduite/models/robot_command.dart';


class ControllerScreen extends StatelessWidget {
  const ControllerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RobotController>();

    return Scaffold(
      backgroundColor: const Color(0xFF001133), // Bleu nuit

      appBar: AppBar(
        title: const Text(
          "Contrôleur Avancé",
          style: TextStyle(fontFamily: 'Rajdhani'),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            //  STATUTS SECTION
            const Text(
              "Diagnostic Système",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Rajdhani',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            _buildStatusTile(
              icon: Icons.battery_6_bar,
              title: "Voltage Batterie",
              value: "12.6 V",  // À remplacer si ESP32 renvoie la valeur
            ),

            const SizedBox(height: 15),

            _buildStatusTile(
              icon: Icons.bluetooth_connected,
              title: "Bluetooth",
              value: controller.connectionState.name.toUpperCase(),
            ),

            const SizedBox(height: 15),

            _buildStatusTile(
              icon: Icons.sensors,
              title: "Gyroscope / MPU",
              value: controller.mpuData,
            ),

            const SizedBox(height: 40),

            // --- TESTS SECTION ---
            const Text(
              "Tests Matériels",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Rajdhani',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.blueAccent.withOpacity(0.5),
                elevation: 10,
              ),
              onPressed: () {
                controller.sendCommand(Command.accel);
                Future.delayed(const Duration(milliseconds: 600), () {
                  controller.sendCommand(Command.stop);
                });
              },
              child: const Text(
                "Tester Moteurs",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Rajdhani',
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                controller.sendCommand(Command.stop);
              },
              child: const Text(
                "Arrêt d'Urgence",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Rajdhani',
                  color: Colors.white,
                ),
              ),
            ),

            const Spacer(),

            const Text(
              "PIPE-FAMILY SYSTEM © 2024",
              style: TextStyle(
                color: Colors.white38,
                fontFamily: 'Rajdhani',
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  //  WIDGET FUTURISTE DIAGNOSTIC
  Widget _buildStatusTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white30),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(icon, size: 35, color: Colors.blueAccent),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Rajdhani',
                fontSize: 18,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'Rajdhani',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
