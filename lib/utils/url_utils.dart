import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Utils {
  Utils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchWhatsapp(String number) async {
    // var whatsappUrl ="whatsapp://send?phone=$phone";
    // await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
    final url = "whatsapp://send?phone=$number";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchEmail(String email) async {
    final url = "mailto:$email";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch';
    }
  }

  static Future<void> launchMessenger(String id) async {
    String url() {
      if (Platform.isAndroid) {
        String uri = 'fb-messenger://user/$id';
        return uri;
      } else if (Platform.isIOS) {
        // iOS
        String uri = 'https://m.me/$id';
        return uri;
      } else {
        return 'error';
      }
    }

    if (await canLaunchUrl(Uri.parse(url()))) {
      await launchUrl(Uri.parse(url()));
    } else {
      throw 'Could not launch';
    }
  }
}
