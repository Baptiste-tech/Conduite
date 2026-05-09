import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

import 'package:conduite/providers/robot_controller.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  List<BluetoothDevice> devices = [];
  bool scanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  // ---------------------------------------------------------
  //                 SCAN BLUETOOTH
  // ---------------------------------------------------------
  void _startScan() async {
    setState(() {
      scanning = true;
      devices = [];
    });

    bool? enabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (enabled == false) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      if (result.device.name != null &&
          !devices.any((d) => d.address == result.device.address)) {
        setState(() => devices.add(result.device));
      }
    }).onDone(() {
      setState(() => scanning = false);
    });
  }


  //MODE SIMULATION

  void _simulateConnection(BuildContext context) {
    final controller = context.read<RobotController>();

    controller.enableSimulation();      // ✔ méthode correcte
    Navigator.of(context).pushReplacementNamed('/pilot');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RobotController>();

    return Scaffold(
      backgroundColor: const Color(0xFF001133),

      appBar: AppBar(
        title: const Text("Connexion", style: TextStyle(fontFamily: 'Rajdhani')),
        backgroundColor: Colors.black,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),

        actions: [
          // BOUTON MODE SIMULATION
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.amber, size: 30),
            tooltip: "Mode Simulation",
            onPressed: () => _simulateConnection(context),
          ),

          IconButton(
            icon: const Icon(Icons.refresh, size: 28),
            onPressed: scanning ? null : _startScan,
          ),
          const SizedBox(width: 15)
        ],
      ),


      //                LISTE DES APPAREILS

      body: Column(
        children: [
          const SizedBox(height: 15),

          Text(
            controller.lastStatus,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontFamily: 'Rajdhani',
            ),
          ),

          if (scanning)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: LinearProgressIndicator(color: Colors.blueAccent),
            ),

          Expanded(
            child: devices.isEmpty
                ? const Center(
              child: Text(
                "Aucun appareil trouvé",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
                : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = devices[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),

                  child: ListTile(
                    leading: const Icon(Icons.bluetooth,
                        color: Colors.blueAccent, size: 30),

                    title: Text(
                      device.name ?? "Appareil inconnu",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Rajdhani',
                        fontSize: 18,
                      ),
                    ),

                    subtitle: Text(
                      device.address,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontFamily: 'Rajdhani',
                      ),
                    ),

                    onTap: () async {
                      await controller.connectToDevice(device);

                      if (controller.connectionState ==
                          RobotConnectionState.connected) {
                        Navigator.of(context)
                            .pushReplacementNamed('/pilot');
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
