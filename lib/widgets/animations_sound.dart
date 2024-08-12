import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class VisualComponent extends StatefulWidget {
  final int duration;
  final Color color;
  final bool isAnimating;

  const VisualComponent({
    super.key,
    required this.duration,
    required this.color,
    required this.isAnimating,
  });

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));
    final curveAnimation =
        CurvedAnimation(parent: animController, curve: Curves.decelerate);

    // Cambiar el valor inicial de la animación de 0.0 a 80.0
    animation = Tween<double>(begin: 0.0, end: 80.0).animate(curveAnimation)
      ..addListener(() {
        setState(() {});
      });

    // Iniciar la animación basada en el valor de isAnimating
    if (widget.isAnimating) {
      animController.repeat(reverse: true);
      log("Entro al initState para animarse");
    }
  }

  @override
  void didUpdateWidget(covariant VisualComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating && !oldWidget.isAnimating) {
      animController.repeat(reverse: true);
      log("Iniciar animación");
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      animController.stop();
      log("Detener animación");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(2)),
      height: widget.isAnimating
          ? math.max(1.0, animation.value)
          : 80, // Asegurarse de que la altura sea 80 cuando no esté animando
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}

class MusicVisualizer extends StatefulWidget {
  final bool playRadio;
  const MusicVisualizer({super.key, required this.playRadio});

  @override
  State<MusicVisualizer> createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer> {
  @override
  Widget build(BuildContext context) {
    List<int> durations = [900, 700, 600, 800, 500];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
        6,
        (index) => VisualComponent(
          duration: durations[index % durations.length],
          color: Colors.black,
          isAnimating: widget.playRadio,
        ),
      ),
    );
  }
}
