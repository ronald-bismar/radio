import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  final bool playRadio;

  const CustomLinearProgressIndicator({super.key, required this.playRadio});

  @override
  State<CustomLinearProgressIndicator> createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState
    extends State<CustomLinearProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      child: LinearProgressIndicator(

        color: Colors.blue, // null usa el color predeterminado
        value: widget.playRadio ? 0 : 100,
      ),
    );
  }
}
