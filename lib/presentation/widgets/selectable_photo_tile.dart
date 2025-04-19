

import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_dimens.dart';
import '../../core/services/thumbnail_processor.dart';
import 'ProgressiveImage.dart';

class SelectablePhotoTile extends StatelessWidget {
  final String photoId;
  final String uri;
  final bool isSelected;
  final VoidCallback onToggle;
  final ThumbnailProcessor thumbnailProcessor;

  const SelectablePhotoTile({
    super.key,
    required this.photoId,
    required this.uri,
    required this.isSelected,
    required this.onToggle,
    required this.thumbnailProcessor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              AppDimens.radius6,
            ),
            child: ImageFiltered(
              imageFilter:
              isSelected
                  ? ImageFilter.blur(sigmaX: 2, sigmaY: 2)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: ProgressiveImage(
                uri: uri,
                thumbnailProcessor: thumbnailProcessor,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          if (isSelected)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.check_circle, color: Colors.greenAccent, size: AppDimens.dimen22),
              ),
            ),
        ],
      ),
    );
  }
}