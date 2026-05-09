import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    // Animation du glow des boutons
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF001133),

      body: Stack(
        children: [

          // 🔵 ANIMATION FOND HOLOGRAPHIQUE
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(_glow.value),
                      Colors.transparent,
                    ],
                    radius: 1.2,
                    center: Alignment(0, -0.4),
                  ),
                ),
              );
            },
          ),

          // MENU
          Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  _menuButton(
                    icon: Icons.home,
                    text: "ACCUEIL",
                    route: '/home',
                  ),

                  const SizedBox(height: 20),

                  _menuButton(
                    icon: Icons.sports_motorsports,   // 🪖 casques pilote
                    text: "ÉCRAN DE PILOTE",
                    route: '/pilot',
                  ),

                  const SizedBox(height: 20),

                  _menuButton(
                    icon: Icons.bluetooth_connected, // 📡 Bluetooth
                    text: "CONNEXION",
                    route: '/connection',
                  ),

                  const SizedBox(height: 20),

                  _menuButton(
                    icon: Icons.settings, // ⚙️ Settings
                    text: "PARAMÈTRES",
                    route: '/settings',
                  ),

                  const SizedBox(height: 20),

                  _menuButton(
                    icon: Icons.gamepad, // 🎮 manette
                    text: "CONTRÔLEUR",
                    route: '/controller',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String text,
    required String route,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.withOpacity(0.8),
            padding: const EdgeInsets.symmetric(vertical: 18),
            minimumSize: const Size(double.infinity, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.blueAccent.withOpacity(_glow.value),
            elevation: 15,
          ),
          onPressed: () => Navigator.pushNamed(context, route),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              const SizedBox(width: 15),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Rajdhani',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
