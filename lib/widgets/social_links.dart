import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinks extends StatelessWidget {
  final List<SocialLink> links = [
    SocialLink(
        'assets/img/youtube.png',
        'youtube://@filadelfiaiglesiaconpropos5564',
        'http://www.youtube.com/@filadelfiaiglesiaconpropos5564'),
    SocialLink(
        'assets/img/insta.png',
        'instagram://user?username=filadelfiaradio',
        'http://filadelfiaradio.rf.gd/?fbclid=IwY2xjawEiCShleHRuA2FlbQIxMAABHQhIQ8QtNVBk6SPKK556nrLxU6AfiHvUcQMW7n5UmLEKNt3Jrrn3Zuqegw_aem_6GyHI6DlRXvP1GPaVz5S3w&i=1#'),
    SocialLink(
        'assets/img/what.png',
        'whatsapp://chat?code=CRxHUmHcDUmA1LNa6CBKHo',
        'https://chat.whatsapp.com/CRxHUmHcDUmA1LNa6CBKHo'),
    SocialLink('assets/img/feis.png', 'fb://page/CEFiladelfiaCentral',
        'https://www.facebook.com/CEFiladelfiaCentral/'),
  ];

  SocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: links.map((link) => _buildSocialLink(link)).toList(),
        ),
      ),
    );
  }

  Widget _buildSocialLink(SocialLink link) {
    return GestureDetector(
      onTap: () => _launchURL(link),
      child: Image.asset(
        link.iconPath,
        height: 40,
        width: 40,
      ),
    );
  }

  Future<void> _launchURL(SocialLink link) async {
    try {
      // Intenta abrir la aplicación primero
      final Uri appUri = Uri.parse(link.appUrl);
      final Uri webUri = Uri.parse(link.webUrl);

      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri);
      } else if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        log('No se pudo abrir la URL: ${link.webUrl}');
      }
    } catch (e) {
      log('Error al abrir el enlace: $e');
    }
  }
}

class SocialLink {
  final String iconPath;
  final String appUrl;
  final String webUrl;

  SocialLink(this.iconPath, this.appUrl, this.webUrl);
}
