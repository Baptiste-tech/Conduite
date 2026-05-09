import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conduite/providers/robot_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RobotController>();

    return Scaffold(
      backgroundColor: const Color(0xFF001133),

      appBar: AppBar(
        title: const Text(
          'Paramètres',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              "Réglages du pilote",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Rajdhani',
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 30),

            // -----------------------------------------------------
            // 🎚 SENSIBILITÉ DU STICK
            // -----------------------------------------------------
            _buildSlider(
              title: "Sensibilité du stick",
              value: controller.touchSensitivity,
              icon: Icons.gamepad,
              min: 0.5,
              max: 2.0,
              onChanged: (v) => controller.setTouchSensitivity(v),
            ),

            const SizedBox(height: 25),

            // -----------------------------------------------------
            // 🎨 COULEUR DE FOND
            // -----------------------------------------------------
            _buildColorSelector(
              context: context,
              title: "Couleur de fond",
              icon: Icons.color_lens,
              currentColor: Color(controller.backgroundColor),
              onColorSelected: (color) =>
                  controller.setBackgroundColor(color.value),
            ),

            const SizedBox(height: 25),

            // -----------------------------------------------------
            // 🔵 COULEUR GLOW DES BOUTONS
            // -----------------------------------------------------
            _buildColorSelector(
              context: context,
              title: "Glow des boutons",
              icon: Icons.brightness_5,
              currentColor: Color(controller.buttonGlowColor),
              onColorSelected: (color) =>
                  controller.setButtonGlowColor(color.value),
            ),

            const SizedBox(height: 25),

            // -----------------------------------------------------
            // 🚗 MODE AUTOMATIQUE
            // -----------------------------------------------------
            _buildSwitch(
              title: "Mode automatique (IA)",
              icon: Icons.smart_toy,
              value: controller.autoMode,
              onChanged: (v) => controller.setAutoMode(v),
            ),
            // 🔥 BOUTON RÉINITIALISER LES COULEURS
            GestureDetector(
              onTap: () {
                final controller = context.read<RobotController>();
                controller.resetColors();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.redAccent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.restore, color: Colors.redAccent, size: 28),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        "Réinitialiser les couleurs",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Rajdhani',
                          fontSize: 18,
                        ),
                      ),
                    ), 
                  ],
                ),
              ),
            ),

            const Spacer(),

            const Center(
              child: Text(
                "Paramètres avancés bientôt disponibles...",
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'Rajdhani',
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 🟦 MODULE SLIDER
  // -------------------------------------------------------------
  Widget _buildSlider({
    required String title,
    required double value,
    required IconData icon,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 26),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Rajdhani')),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: 10,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }


  // CHANGEMENT   DES COULEUR

  Widget _buildColorSelector({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color currentColor,
    required Function(Color) onColorSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxStyle(),
      child: Row(
        children: [
          Icon(icon, color: currentColor, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Rajdhani'),
            ),
          ),

          // Prévisualisation couleur
          GestureDetector(
            onTap: () {
              _openColorPicker(context, currentColor, onColorSelected);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openColorPicker(
      BuildContext context,
      Color current,
      Function(Color) onSelected,
      ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF001133),
          title: const Text("Choisir une couleur",
              style: TextStyle(color: Colors.white, fontFamily: 'Rajdhani')),
          content: Wrap(
            children: [
              _colorDot(Colors.cyanAccent, onSelected),
              _colorDot(Colors.greenAccent, onSelected),
              _colorDot(Colors.purpleAccent, onSelected),
              _colorDot(Colors.redAccent, onSelected),
              _colorDot(Colors.orangeAccent, onSelected),
              _colorDot(Colors.blueAccent, onSelected),
            ],
          ),
        );
      },
    );
  }

  Widget _colorDot(Color c, Function(Color) onTap) {
    return GestureDetector(
      onTap: () => onTap(c),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: c,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 🔘 SWITCH
  // -------------------------------------------------------------
  Widget _buildSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxStyle(),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Rajdhani')),
          ),
          Switch(
            value: value,
            activeColor: Colors.blueAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // STYLE BOÎTE
  // -------------------------------------------------------------
  BoxDecoration _boxStyle() {
    return BoxDecoration(
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
    );
  }
}
