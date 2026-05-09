import 'package:flutter/material.dart';
import 'dart:async';

class GlowButton extends StatefulWidget {
  final Widget child;
  final double size;
  final VoidCallback onTap;
  final VoidCallback? onHold; // NOUVEAU : pour maintien continu
  final Color glowColor;
  final bool holdable; // NOUVEAU : true pour maintien, false pour impulsion

  const GlowButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.glowColor,
    this.size = 60,
    this.onHold, // NOUVEAU
    this.holdable = false, // NOUVEAU : par défaut impulsion
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool pressed = false;
  Timer? _holdTimer;

  void _startHold() {
    if (widget.holdable && widget.onHold != null) {
      _holdTimer?.cancel();
      _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        widget.onHold!();
      });
    }
  }

  void _stopHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
  }

  @override
  void dispose() {
    _stopHold();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => pressed = true);
        _startHold();
      },
      onTapUp: (_) {
        widget.onTap();
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() => pressed = false);
        });
        _stopHold();
      },
      onTapCancel: () {
        setState(() => pressed = false);
        _stopHold();
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: pressed ? 1.15 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: widget.glowColor, width: 3),
            boxShadow: pressed
                ? [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.7),
                blurRadius: 25,
                spreadRadius: 6,
              )
            ]
                : [],
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}