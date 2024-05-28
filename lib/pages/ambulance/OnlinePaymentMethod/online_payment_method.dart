import 'package:flutter/material.dart';
import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';
import 'package:shebaone/utils/global.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;


class OnlinePaymentMethod extends StatefulWidget {
    OnlinePaymentMethod({Key? key,
    required this.mamount,
    required this.ssl_id,
    required this.Q,
    required this.SESSIONKEY,
    required this.tran_type,
    required this.cardname,
    }) : super(key: key);
 String ? mamount;
 String ? ssl_id;
 String ? Q;
 String ? SESSIONKEY;
 String ? tran_type;
 String ? cardname;
  @override
  State<OnlinePaymentMethod> createState() => _OnlinePaymentMethodState();
}

class _OnlinePaymentMethodState extends State<OnlinePaymentMethod> {
  WebViewController? _controller;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            globalLogger.d(progress);
            if (progress == 100) {
              isLoading = false;
              setState(() {});
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse("https://sandbox.sslcommerz.com/gwprocess/v4/bankgw/indexhtmlOTP.php?mamount=${widget.mamount}&ssl_id=231110182008VZkZ3pZTUkc8aiR&Q=REDIRECT&SESSIONKEY=CF1A998979D93462F8EDAC60C6BF5354&tran_type=success&cardname=dbblmobilebanking"));

    initFilePicker();
    super.initState();
  }

  initFilePicker() async {
    if (Platform.isAndroid) {
      final androidController = (_controller!.platform as webview_flutter_android.AndroidWebViewController);
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(webview_flutter_android.FileSelectorParams params) async {
    if (params.acceptTypes.any((type) => type == 'image/*')) {
      final picker = image_picker.ImagePicker();
      final photo = await picker.pickImage(source: image_picker.ImageSource.gallery);

      if (photo == null) {
        return [];
      }

      final imageData = await photo.readAsBytes();
      final decodedImage = image.decodeImage(imageData)!;
      final scaledImage = image.copyResize(decodedImage, width: 500);
      final jpg = image.encodeJpg(scaledImage, quality: 90);

      final filePath = (await getTemporaryDirectory()).uri.resolve(
        './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
      );
      final file = await File.fromUri(filePath).create(recursive: true);
      await file.writeAsBytes(jpg, flush: true);

      return [file.uri.toString()];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Payment method")),
        body:  WebViewWidget(

          controller: _controller!,
        ),);
  }
}
