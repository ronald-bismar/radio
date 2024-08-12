import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio/resources/Colores.dart';
import 'package:radio/widgets/animations_sound.dart';
import 'package:radio/widgets/bar_progress_indicator.dart';
import 'package:radio/widgets/frosted_glass_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radio Filadelfia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Filadelfia Radio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool playRadio = false;
  bool muteRadio = false;
  String actualTime = "00:00";
  String totalTime = "00:00";
  String urlRadio = 'http://stream.zeno.fm/fd9bandxezzuv';

  // Colores para Neumorfismo
  final Color baseColor = const Color.fromARGB(255, 236, 236, 236);
  final Color shadowLight = Colors.white;
  final Color shadowDark = const Color(0xFFA3B1C6);
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    opacityLevel = playRadio ? 0.0 : 1.0;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  updateButtons() {
    setState(() {
      playRadio = !playRadio;
      log("playRadio: $playRadio");
      opacityLevel = playRadio ? 0.0 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: SizedBox(
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
                alignment: Alignment.bottomCenter,
                child: botonGrandeYAnimacion()),
            reproductor(),
            Align(alignment: Alignment.bottomCenter, child: parteBaja())
          ],
        ),
      ),
    );
  }

  Widget playOrPause() {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(2),
      onPressed: () => encenderRadio(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          playRadio ? Icons.pause : Icons.play_arrow,
          color: tertiary,
          key: ValueKey<bool>(playRadio),
        ),
      ),
    );
  }

  time(String actualTime, String totalTime) {
    return Text(
      "$actualTime/$totalTime",
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.black,
        shadows: [
          Shadow(
            color: Colors.white,
            blurRadius: 10.0,
          ),
          Shadow(
            color: Colors.white,
            blurRadius: 12.0,
          ),
        ],
      ),
    );
  }

  lineTime() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CustomLinearProgressIndicator(
        playRadio: !playRadio,
      ),
    ));
  }

  soundOrMute() {
    return IconButton(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(2),
        onPressed: () => _setVolume(),
        icon: Icon(
          muteRadio ? Icons.volume_off : Icons.volume_up,
          color: tertiary,
        ));
  }

  options() {
    return const Icon(
      Icons.more_vert,
      color: Colors.black,
      size: 22.0,
    );
  }

  reproductor() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            offset: const Offset(5, 5),
            blurRadius: 15,
          ),
          BoxShadow(
            color: shadowLight,
            offset: const Offset(-5, -5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          playOrPause(),
          time(actualTime, totalTime),
          lineTime(),
          soundOrMute(),
          options()
        ],
      ),
    );
  }

  parteBaja() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          imageLink('assets/img/playstore.png', ''),
          imageLink('assets/img/insta.png', ''),
          imageLink('assets/img/what.png', ''),
          imageLink('assets/img/feis.png', ''),
          imageLink('assets/img/compa.png', ''),
        ],
      ),
    );
  }

  imageLink(String addressResource, String urlSocialMedia) {
    return GestureDetector(
      onTap: () => {},
      child: Image.asset(
        addressResource,
        height: 40,
        width: 40,
      ),
    );
  }

  title() {
    return Container(
      padding: const EdgeInsets.only(
        top: 60,
      ),
      child: const Text(
        "Filadelfia Radio",
        style: TextStyle(
            fontFamily: 'Sriracha', fontSize: 40, color: Colors.white),
      ),
    );
  }

  void _setVolume() {
    updateStateMute();
    if (muteRadio) {
      _audioPlayer.setVolume(0.0);
    } else {
      _audioPlayer.setVolume(1.0);
    }
  }

  void encenderRadio() async {
    updateButtons();
    if (!playRadio) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.setUrl(urlRadio);
      await _audioPlayer.play();
    }
  }

  void updateStateMute() {
    setState(() {
      muteRadio = !muteRadio;
    });
  }

  botonGrandeYAnimacion() {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.transparent,
          border: Border.all(color: const Color.fromARGB(221, 196, 196, 196))),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset('assets/img/portada.jpg',
                fit: BoxFit.cover), //Imagen de fondo de la seccion
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: opacityLevel,
              duration: const Duration(milliseconds: 300),
              child: const FrostedGlassBox(
                theWidth: double.infinity,
                theHeight: double.infinity,
              ),
            ),
          ),
          contenidoImagen(),
        ],
      ),
    );
  }

  contenidoImagen() {
    return Positioned.fill(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title(),
          botonGrande(),
          animacion(),
        ],
      ),
    );
  }

  botonGrande() {
    return Container(
      height: 150,
      width: 150,
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 3, 54, 136),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            offset: const Offset(10, 10),
            blurRadius: 30,
          ),
          BoxShadow(
            color: shadowDark,
            offset: const Offset(-10, -10),
            blurRadius: 30,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => encenderRadio(),
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            playRadio ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 120,
            key: ValueKey<bool>(playRadio),
          ),
        ),
      ),
    );
  }

  animacion() {
    log("playRadio: $playRadio");
    return Transform.scale(
      scale: 0.3,
      child: Container(
        padding: const EdgeInsets.only(bottom: 50),
        height: 100,
        child: MusicVisualizer(
          playRadio: playRadio,
        ),
      ),
    );
  }
}
