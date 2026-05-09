import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001133), // Bleu nuit futuriste

      appBar: AppBar(
        title: const Text(
          'À Propos',
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
          children: [

            const SizedBox(height: 30),

            // --- Logo futuriste circulaire ---
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF003366), Color(0xFF005599)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.7),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "PIP-FAMILY SYSTEM",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Rajdhani',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            const Text(
              "Application de pilotage IA du robot industriel.",
              style: TextStyle(
                color: Colors.white70,
                fontFamily: 'Rajdhani',
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // Section informations
            _infoItem(
              icon: Icons.engineering,
              title: "Chef de Projet Logiciel & IA",
              subtitle: "MIAGE L3",
            ),

            const SizedBox(height: 15),

            _infoItem(
              icon: Icons.code,
              title: "Développement Mobile",
              subtitle: "Étudiant 2",
            ),

            const SizedBox(height: 15),

            _infoItem(
              icon: Icons.memory_outlined,
              title: "Support Logiciel",
              subtitle: "Étudiant 3",
            ),

            const Spacer(),

            const Text(
              "© 2024 PIP-FAMILY - Tous droits réservés",
              style: TextStyle(
                color: Colors.white38,
                fontFamily: 'Rajdhani',
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Widget d'information ---
  Widget _infoItem({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Rajdhani',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white60,
                  fontFamily: 'Rajdhani',
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
