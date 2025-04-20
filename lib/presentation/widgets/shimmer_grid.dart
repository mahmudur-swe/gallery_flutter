import 'package:flutter/cupertino.dart';
import 'package:gallery_flutter/presentation/widgets/placeholder.dart';

import '../../core/constants/app_dimens.dart';

class ShimmerPhotoGrid extends StatelessWidget {
  const ShimmerPhotoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.padding12,
        left: AppDimens.padding12,
        right: AppDimens.padding12,
        bottom: AppDimens.padding100,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 30, // simulate 30 placeholders
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          return ShimmerPlaceholder();
        },
      ),
    );
  }
}
