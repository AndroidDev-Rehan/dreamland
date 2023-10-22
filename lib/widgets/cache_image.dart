import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Constants/AppConstants.dart';

class CustomCacheImage extends StatelessWidget {
  const CustomCacheImage({Key? key, required this.imgUrl, this.fullScreen = false}) : super(key: key);

  final String? imgUrl;
  final bool fullScreen;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          (imgUrl == null || imgUrl!.isEmpty) ? AppConstants.NO_IMAGE : imgUrl!,
      height: fullScreen ? 1.sh : 140,
      width: fullScreen ? 1.sw : 120,
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
