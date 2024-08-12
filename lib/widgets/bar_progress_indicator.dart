import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  final bool playRadio; // Asegúrate de especificar el tipo booleano
  const CustomLinearProgressIndicator({super.key, required this.playRadio});

  @override
  State<CustomLinearProgressIndicator> createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState
    extends State<CustomLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    // Iniciar la animación basada en el valor inicial de playRadio
    if (widget.playRadio) {
      animationController.forward();
    } else {
      animationController.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(covariant CustomLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar animación si el valor de playRadio cambia
    if (widget.playRadio && !oldWidget.playRadio) {
      animationController.forward();
    } else if (!widget.playRadio && oldWidget.playRadio) {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: Colors.blue,
      value: animationController.value,
    );
  }
}
