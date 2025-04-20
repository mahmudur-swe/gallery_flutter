import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
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
            // Base low-res image
            ClipRRect(
              borderRadius: borderRadius,
              child: Image.memory(
                lowSnap.data!,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),

            // Overlay high-res when ready
            FutureBuilder<Uint8List?>(
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
