import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../Constants/AppConstants.dart';

class CustomCacheImage extends StatelessWidget {
  const CustomCacheImage({Key? key, required this.imgUrl}) : super(key: key);

  final String? imgUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          (imgUrl == null || imgUrl!.isEmpty) ? AppConstants.NO_IMAGE : imgUrl!,
      height: 140,
      width: 120,
      placeholder: (context, url) => const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image),
          SizedBox(
            height: 10,
          ),
          Text('Loading...'),
        ],
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
