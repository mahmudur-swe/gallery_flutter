import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_flutter/core/constants/app_dimens.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/ic_photos.svg',
                width: AppDimens.dimen123,
              ),
              const SizedBox(height: AppDimens.space42),
              Text(
                'Require Permission',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: AppDimens.space8),
              Text(
                'To show your black and white photos.\nWe just need your folder permission.\nWe promise, we don’t take your photos.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppDimens.space42),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    //todo: request permission
                  },
                  child: const Text("Grant Access"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
