import 'package:flutter/material.dart';
import 'package:shebaone/utils/constants.dart';

class ImagePreview extends StatefulWidget {
  List<String> imageList;
  int index;
  String title;

  ImagePreview({Key? key, required this.imageList, required this.index, required this.title}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(
        //   color: Colors.black, //change your color here
        // ),
        // automaticallyImplyLeading: false,
        backgroundColor: kScaffoldColor,
        title: Text(
          widget.title,
          style: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xff626365),
                  Color(0xffCAC6C3),
                ],
              ),
            ),
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3.0,
              child: NetworkImageWidget(
                height: size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                width: size.width,
                image: widget.imageList[widget.index],
                boxFit: BoxFit.contain,
              ),
            ),
          ),
          Visibility(
            visible: widget.index > 0,
            child: Positioned(
                top: (size.height / 2) - 22.5,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    if (widget.index > 0) {
                      setState(() {
                        widget.index--;
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                )),
          ),
          Visibility(
            visible: widget.index < widget.imageList.length - 1,
            child: Positioned(
                top: (size.height / 2) - 22.5,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    if (widget.index < widget.imageList.length - 1) {
                      setState(() {
                        widget.index++;
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

enum NetworkImageBorder {
  Circle,
  Rectangle,
}

class NetworkImageWidget extends StatefulWidget {
  const NetworkImageWidget({
    Key? key,
    required this.image,
    this.border = NetworkImageBorder.Rectangle,
    this.height = 48,
    this.width = 48,
    this.boxFit = BoxFit.cover,
    // this.color = const Color(0xFF000000),
  }) : super(key: key);

  final String image;
  final double height;
  final double width;
  final BoxFit boxFit;
  final NetworkImageBorder border;

  @override
  _NetworkImageWidgetState createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  dynamic _imageWidget() {
    // TODO in future add a cachedNetworkimage
    // otherwise the network toll will be much higher
    // CachedNetworkImage(
    //   imageUrl: "http://via.placeholder.com/200x150",
    //   imageBuilder: (context, imageProvider) => Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //           image: imageProvider,
    //           fit: BoxFit.cover,
    //           colorFilter:
    //           ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
    //     ),
    //   ),
    //   placeholder: (context, url) => CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => Icon(Icons.error),
    // ),

    return FadeInImage(
      fadeInDuration: const Duration(milliseconds: 500),
      fadeInCurve: Curves.decelerate,
      placeholder: const AssetImage("assets/images/image_loading.gif"),
      image: NetworkImage(
        widget.image,
      ),
      imageErrorBuilder: (context, error, stackTrace) {
        // _authenticateAndRefresh();
        return Image.asset("assets/images/image_loading.gif");
      },
      width: widget.width,
      height: widget.height,
      fit: widget.boxFit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.border == NetworkImageBorder.Rectangle
        ? _imageWidget()
        : ClipRRect(borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height), child: _imageWidget());
  }
}
