import 'package:flutter/material.dart';
import 'dart:math';

class DynamicStick extends StatefulWidget {
  final Color glowColor;
  final double size;
  final Function(Offset direction) onChanged;
  final VoidCallback onRelease;

  // NOUVEAU : sensibilité du stick (défaut = 1.0)
  final double sensitivity;

  const DynamicStick({
    super.key,
    required this.glowColor,
    required this.size,
    required this.onChanged,
    required this.onRelease,
    this.sensitivity = 1.0,   //  Valeur par défaut
  });

  @override
  State<DynamicStick> createState() => _DynamicStickState();
}

class _DynamicStickState extends State<DynamicStick> {
  Offset knobPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    double radius = widget.size / 2;

    return GestureDetector(
      onPanUpdate: (details) {
        Offset newPos = knobPosition + details.delta;

        // Limite du déplacement dans le cercle
        if (newPos.distance <= radius * 0.7) {
          setState(() {
            knobPosition = newPos;
          });

          // Application de la sensibilité
          Offset normalized = (knobPosition / (radius * 0.7)) * widget.sensitivity;

          // Clamp entre -1 et 1 pour éviter des valeurs extrêmes
          normalized = Offset(
            normalized.dx.clamp(-1.0, 1.0),
            normalized.dy.clamp(-1.0, 1.0),
          );

          widget.onChanged(normalized);
        }
      },

      onPanEnd: (_) {
        setState(() => knobPosition = Offset.zero);
        widget.onRelease();
      },

      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: widget.glowColor, width: 3),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withOpacity(0.5),
              blurRadius: 25,
              spreadRadius: 6,
            )
          ],
        ),
        child: Center(
          child: Transform.translate(
            offset: knobPosition,
            child: Container(
              width: widget.size * 0.35,
              height: widget.size * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.glowColor.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
