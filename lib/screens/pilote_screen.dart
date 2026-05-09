import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:conduite/providers/robot_controller.dart';
import 'package:conduite/models/robot_command.dart';

import '../widgets/dynamic_stick.dart';
import '../widgets/glow_button.dart';

class PilotScreen extends StatefulWidget {
  const PilotScreen({super.key});

  @override
  State<PilotScreen> createState() => _PilotScreenState();
}

class _PilotScreenState extends State<PilotScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RobotController>();
    final size = MediaQuery.of(context).size;

    final background = Color(controller.backgroundColor);
    final glow = Color(controller.buttonGlowColor);
    final sens = controller.touchSensitivity;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // TITRE
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "PILOTAGE",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontFamily: 'Rajdhani',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),

          // Boutons directionnels (GAUCHE)
          Positioned(
            top: size.height * 0.18,
            left: size.width * 0.04,
            child: Column(
              children: [
                // Flèche haut - Accélérer (MAINTENIR)
                GlowButton(
                  glowColor: glow,
                  onTap: () {
                    if (!controller.autoMode) controller.accelerate();
                  },
                  onHold: () {
                    if (!controller.autoMode) controller.accelerate();
                  },
                  holdable: true, // Active le maintien
                  child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),

                // Flèches gauche/droite (MAINTENIR)
                Row(
                  children: [
                    GlowButton(
                      glowColor: glow,
                      onTap: () {
                        if (!controller.autoMode) controller.sendCommand(Command.left);
                      },
                      onHold: () {
                        if (!controller.autoMode) controller.sendCommand(Command.left);
                      },
                      holdable: true,
                      child: const Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 22),
                    GlowButton(
                      glowColor: glow,
                      onTap: () {
                        if (!controller.autoMode) controller.sendCommand(Command.right);
                      },
                      onHold: () {
                        if (!controller.autoMode) controller.sendCommand(Command.right);
                      },
                      holdable: true,
                      child: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Flèche bas - Reculer (MAINTENIR)
                GlowButton(
                  glowColor: glow,
                  onTap: () {
                    if (!controller.autoMode) controller.reverse();
                  },
                  onHold: () {
                    if (!controller.autoMode) controller.reverse();
                  },
                  holdable: true,
                  child: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                ),
              ],
            ),
          ),

          // Joystick gauche
          Positioned(
            bottom: 40,
            left: size.width * 0.23,
            child: DynamicStick(
              glowColor: glow,
              size: size.height * 0.28,
              sensitivity: sens,
              onChanged: (offset) {
                if (controller.autoMode) return;
                if (offset.dx > 0.3) {
                  controller.sendCommand(Command.right);
                } else if (offset.dx < -0.3) {
                  controller.sendCommand(Command.left);
                } else {
                  controller.stop();
                }
              },
              onRelease: () {
                if (!controller.autoMode) controller.stop();
              },
            ),
          ),

          // Boutons PlayStation
          Positioned(
            top: size.height * 0.30,
            right: size.width * 0.09,
            child: SizedBox(
              width: 170,
              height: 180,
              child: Stack(
                children: [
                  // △ TRIANGLE → Reculer (MAINTENIR)
                  Positioned(
                    top: 0,
                    left: 55,
                    child: GlowButton(
                      glowColor: glow,
                      onTap: () {
                        if (!controller.autoMode) controller.reverse();
                      },
                      onHold: () {
                        if (!controller.autoMode) controller.reverse();
                      },
                      holdable: true,
                      child: const Text("△",
                          style: TextStyle(color: Colors.orangeAccent, fontSize: 30)),
                    ),
                  ),

                  // □ CARRÉ → Démarrer (START) - IMPULSION
                  Positioned(
                    top: 55,
                    left: 0,
                    child: GlowButton(
                      glowColor: glow,
                      onTap: () {
                        if (!controller.autoMode) controller.startCar();
                      },
                      // Pas de onHold (impulsion seulement)
                      child: const Text("□",
                          style: TextStyle(color: Colors.purpleAccent, fontSize: 30)),
                    ),
                  ),

                  // ○ ROND → Frein - IMPULSION
                  Positioned(
                    top: 58,
                    right: -4,
                    child: GlowButton(
                      glowColor: glow,
                      onTap: () {
                        if (!controller.autoMode) controller.brake();
                      },
                      // Pas de onHold (impulsion seulement)
                      child: const Text("○",
                          style: TextStyle(color: Colors.redAccent, fontSize: 30)),
                    ),
                  ),

                  // ✕ CROIX → Accélérer (MAINTENIR)
                  Positioned(
                    bottom: 0,
                    left: 55,
                    child: GlowButton(
                      glowColor: glow,
                      onTap: () {
                        if (!controller.autoMode) controller.accelerate();
                      },
                      onHold: () {
                        if (!controller.autoMode) controller.accelerate();
                      },
                      holdable: true,
                      child: const Text("✕",
                          style: TextStyle(color: Colors.greenAccent, fontSize: 32)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Joystick droit (inutilisé)
          Positioned(
            bottom: 40,
            right: size.width * 0.28,
            child: DynamicStick(
              glowColor: glow,
              size: size.height * 0.26,
              sensitivity: sens,
              onChanged: (_) {},
              onRelease: () {},
            ),
          ),
        ],
      ),
    );
  }
}