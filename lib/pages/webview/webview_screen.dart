import 'dart:io';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart' as webview_flutter_android;

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);
  static String routeName = '/WebViewPage';

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
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
      ..loadRequest(Uri.parse(Get.arguments));

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
    return ParentPageWithNav(
      child: Column(
        children: [
          const AppBarWithSearch(
            moduleSearch: ModuleSearch.none,
            isSearchShow: false,
          ),
          Expanded(
            child: isLoading
                ? const SizedBox(
                    height: 100,
                    width: 100,
                    child: Waiting(),
                  )
                : WebViewWidget(
                    controller: _controller!,
                  ),
          ),
          // const SizedBox(
          //   height: 110,
          // ),
        ],
      ),
    );
  }
}
