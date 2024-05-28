import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/services/database.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    Key? key,
    required this.networkImagePath,

    this.errorImagePath,
    this.borderRadius,
    this.imageColor,
    this.width,
    this.height,
    this.isHeightIsNull = false,
    this.isWidthIsNull = false,
    this.fit = BoxFit.fill,
  }) : super(key: key);
  final String networkImagePath;
  final String? errorImagePath;
  final double? borderRadius;
  final Color? imageColor;
  final double? width;
  final double? height;
  final bool isHeightIsNull;
  final bool isWidthIsNull;
  final BoxFit fit;
  // final bool fromAd;
  @override
  Widget build(BuildContext context) {
    // globalLogger.d(networkImagePath.contains(Database().apiUrl.replaceAll('/api', '').replaceAll('www.', ''))
    //     ? networkImagePath
    //     : Database().apiUrl.replaceAll('/api', '') + networkImagePath, 'Image');
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Image.network(
        networkImagePath.contains(Database.apiUrl.replaceAll('/api', '').replaceAll('www.', ''))
            ? networkImagePath
            : Database.apiUrl.replaceAll('/api', '') + networkImagePath,
        fit: fit,
        width: isWidthIsNull ? null : width ,
        height: isHeightIsNull ? null : height ,
        color: imageColor,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, exception, stackTrack) => Image.asset(
          errorImagePath ?? 'assets/icons/error.gif',
          color: imageColor,
          width: isWidthIsNull ? null : width ?? Get.width * .3,
          height: isHeightIsNull ? null : height ?? Get.width * .3,
          fit: fit,
        ),
      ),
    );
  }
}
