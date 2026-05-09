import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.8, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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

          // 🔵 EFFET GRADIENT HOLOGRAPHIQUE
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF003366).withOpacity(0.4),
                  Colors.transparent,
                ],
                radius: 0.9,
                center: Alignment.topCenter,
              ),
            ),
          ),

          // ✨ TITRE PIP-FAMILY ANIMÉ
          Center(
            child: ScaleTransition(
              scale: _pulse,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "PIP-FAMILY",
                    style: TextStyle(
                      fontSize: 52,
                      fontFamily: 'Rajdhani',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.blueAccent,
                          blurRadius: 25,
                          offset: Offset(0, 0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Interface Futuriste",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                      fontFamily: 'Rajdhani',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔥 BOUTON ENTRER AVEC EFFET GLOW
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.8),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(40),
                ),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(200, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/menu');
                  },
                  child: const Text(
                    "ENTRER",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'Rajdhani',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
