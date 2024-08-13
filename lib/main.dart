import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio/resources/colores.dart';
import 'package:radio/widgets/animations_sound.dart';
import 'package:radio/widgets/bar_progress_indicator.dart';
import 'package:radio/widgets/frosted_glass_box.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radio Filadelfia',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            )
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
      home: MyHomePage(
        title: 'Filadelfia Radio',
        onThemeToggle: _toggleTheme,
        isDark: _isDarkMode,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.onThemeToggle,
      required this.isDark});

  final String title;
  final VoidCallback onThemeToggle;
  final bool isDark;

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
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  // Colores segun el tema oscuro o claro
  Color baseColor = baseColorPrimary;
  Color shadowLight = shadowLightPrimary;
  Color shadowDark = shadowDarkPrimary;
  Color colorReproductor = shadowDarkPrimary;

  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    opacityLevel = playRadio ? 0.0 : 1.0;
    setColors();
  }

  void setColors() {
    if (widget.isDark) {
      baseColor = colorExtra;
      shadowLight = colorExtra;
      shadowDark = Colors.black;
      colorReproductor = const Color.fromARGB(255, 93, 175, 226);
    } else {
      baseColor = baseColorPrimary;
      shadowLight = shadowLightPrimary;
      shadowDark = shadowDarkPrimary;
      colorReproductor = primary;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  updateButtons() {
    setState(() {
      playRadio = !playRadio;
      opacityLevel = playRadio ? 0.0 : 1.0;
      if (playRadio) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _elapsedTime = Duration.zero;
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

  Widget time() {
    return Text(
      "${formatDuration(_elapsedTime)}/00:00", // Total time remains "00:00"
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
    return IconButton(
        onPressed: () => _showOptionsMenu(context),
        icon: const Icon(
          Icons.more_vert,
          color: Colors.black,
          size: 22.0,
        ));
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
        color: colorReproductor,
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
        children: [playOrPause(), time(), lineTime(), soundOrMute(), options()],
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
          imageLink('assets/img/playstore.png',
              'http://filadelfiaradio.rf.gd/?fbclid=IwY2xjawEiCShleHRuA2FlbQIxMAABHQhIQ8QtNVBk6SPKK556nrLxU6AfiHvUcQMW7n5UmLEKNt3Jrrn3Zuqegw_aem_6GyHI6DlRXvP1GPaVz5S3w&i=1#'),
          imageLink('assets/img/insta.png',
              'http://filadelfiaradio.rf.gd/?fbclid=IwY2xjawEiCShleHRuA2FlbQIxMAABHQhIQ8QtNVBk6SPKK556nrLxU6AfiHvUcQMW7n5UmLEKNt3Jrrn3Zuqegw_aem_6GyHI6DlRXvP1GPaVz5S3w&i=1#'),
          imageLink('assets/img/what.png',
              'https://chat.whatsapp.com/CRxHUmHcDUmA1LNa6CBKHo'),
          imageLink('assets/img/feis.png',
              'https://www.facebook.com/CEFiladelfiaCentral/'),
          imageLink('assets/img/compa.png', ''),
        ],
      ),
    );
  }

  imageLink(String addressResource, String urlSocialMedia) {
    return GestureDetector(
      onTap: () async => await _launchURL(urlSocialMedia),
      child: Image.asset(
        addressResource,
        height: 40,
        width: 40,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      log("Se llego hasta aqui si no se pudo entrar");
      await launchUrl(uri);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  title() {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "Filadelfia Radio",
            style: TextStyle(
                fontFamily: 'Sriracha', fontSize: 35, color: Colors.white),
          ),
          Image.asset(
            'assets/img/logo.png',
            height: 50,
          )
        ],
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
      _stopTimer();
    } else {
      await _audioPlayer.setUrl(urlRadio);
      await _audioPlayer.play();
      _startTimer();
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
          border: Border.all(color: shadowDark)),
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset('assets/img/portada.jpeg',
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

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.brightness_4),
              title: Text(widget.isDark ? 'Modo Claro' : 'Modo Oscuro'),
              onTap: () {
                // Cerrar el modal
                Navigator.pop(context);
                setState(() {
                  setColors();
                });
                // Cambiar el tema
                widget.onThemeToggle();
              },
            ),
          ],
        );
      },
    );
  }
}
