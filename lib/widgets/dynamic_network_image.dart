import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';

class DynamicNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final FilterQuality filterQuality;
  const DynamicNetworkImage(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
    this.filterQuality = FilterQuality.low,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    if (imageUrl.toLowerCase().contains('.svg')) {
      return CachedNetworkSVGImage(
        imageUrl,
        width: width,
        height: height,

        placeholderBuilder: (context) =>
            Center(child: CircularProgressIndicator()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        filterQuality: filterQuality,
        memCacheHeight: height != null ? (height! * dpr).round() : null,
        memCacheWidth: width != null ? (width! * dpr).round() : null,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
