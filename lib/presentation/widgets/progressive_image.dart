import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_flutter/core/services/thumbnail_processor.dart';
import 'package:gallery_flutter/presentation/widgets/placeholder.dart';

import '../../core/constants/app_dimens.dart';

class ProgressiveImage extends StatelessWidget {
  final String uri;
  final ThumbnailProcessor thumbnailProcessor;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ProgressiveImage({
    super.key,
    required this.uri,
    required this.thumbnailProcessor,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppDimens.radius6),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(

      /// Loading low resolution image from cache/disk or from native platform
      future: thumbnailProcessor.loadThumbnail(
        uri,
        resolution: ThumbnailResolution.low,
      ),
      builder: (context, lowSnap) {
        if (lowSnap.hasData == false ||
            lowSnap.connectionState != ConnectionState.done) {
          return ShimmerPlaceholder(); // shimmer or empty
        }

        return Stack(
          fit: StackFit.expand,
          children: [

            /// show this container before the low-res image is loaded
            Container(
              width: width,
              height: height,
              color: Colors.grey.shade300, // Placeholder color while loading
            ),

            /// Load low resolution image from cache/disk or from native platform
            ClipRRect(
              borderRadius: borderRadius,

              child: Image.memory(
                lowSnap.data!,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),

            /// Overlay high resolution when ready
            FutureBuilder<Uint8List?>(

              /// Loading high resolution image from cache/disk or from native platform
              future: thumbnailProcessor.loadThumbnail(
                uri,
                resolution: ThumbnailResolution.high,
              ),
              builder: (context, highSnap) {
                if (!highSnap.hasData ||
                    highSnap.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink(); // No overlay until ready
                }

                return ClipRRect(
                  borderRadius: borderRadius,
                  child: Image.memory(
                    highSnap.data!,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
