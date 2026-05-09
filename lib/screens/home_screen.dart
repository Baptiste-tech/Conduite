import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001133), // Bleu nuit futuriste

      appBar: AppBar(
        title: const Text(
          'Menu Principal',
          style: TextStyle(fontFamily: 'Rajdhani'),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const Text(
              "PIPE-FAMILY SYSTEM",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Rajdhani',
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 40),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 25,
                children: [
                  _buildMenuButton(
                    icon: Icons.home_outlined,
                    label: "Home",
                    onTap: () {},
                  ),

                  _buildMenuButton(
                    icon: Icons.sports_esports_rounded,
                    label: "Écran Pilote",
                    onTap: () {
                      Navigator.of(context).pushNamed('/pilot');
                    },
                  ),

                  _buildMenuButton(
                    icon: Icons.bluetooth_searching_rounded,
                    label: "Connexion",
                    onTap: () {
                      Navigator.of(context).pushNamed('/connection');
                    },
                  ),

                  _buildMenuButton(
                    icon: Icons.settings_outlined,
                    label: "Paramètres",
                    onTap: () {
                      Navigator.of(context).pushNamed('/settings');
                    },
                  ),

                  _buildMenuButton(
                    icon: Icons.control_camera_outlined,
                    label: "Contrôleur",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  WIDGET BOUTUON RON ET FUTURISTE
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 95,
            width: 95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                )
              ],
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF002244),
                  Color(0xFF003366),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              size: 45,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Rajdhani',
            ),
          ),
        ],
      ),
    );
  }
}
