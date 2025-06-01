import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:flutter/material.dart';

class DynamicNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  const DynamicNetworkImage(
    this.imageUrl, {
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
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
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
