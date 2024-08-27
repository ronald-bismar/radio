import 'package:flutter/material.dart';
import 'package:radio/widgets/animations_sound.dart';
import 'package:radio/widgets/frosted_glass_box.dart';

class RadioButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const RadioButton({
    Key? key,
    required this.isPlaying,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Theme.of(context).shadowColor),
      ),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/img/portada.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: const FrostedGlassBox(
              theWidth: double.infinity,
              theHeight: double.infinity,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTitle(),
              _buildPlayButton(),
              _buildVisualizer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Filadelfia Radio",
            style: TextStyle(
              fontFamily: 'Sriracha',
              fontSize: 35,
              color: Colors.white,
            ),
          ),
          Image.asset(
            'assets/img/logo.png',
            height: 60,
          )
        ],
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      height: 150,
      width: 150,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 3, 54, 136),
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(10, 10),
            blurRadius: 30,
          ),
          BoxShadow(
            color: Colors.black54,
            offset: Offset(-10, -10),
            blurRadius: 30,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: ((child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              )),
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 120,
          ),
        ),
      ),
    );
  }

  Widget _buildVisualizer() {
    return Transform.scale(
      scale: 0.3,
      child: Container(
        padding: const EdgeInsets.only(bottom: 50),
        height: 100,
        child: MusicVisualizer(
          playRadio: isPlaying,
        ),
      ),
    );
  }
}
