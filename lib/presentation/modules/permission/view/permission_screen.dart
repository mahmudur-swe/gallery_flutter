import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gallery_flutter/core/constants/app_dimens.dart';
import 'package:gallery_flutter/core/constants/app_string.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_event.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_state.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../routes/router.dart';
import '../bloc/permission_bloc.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check permission when entering the screen
    context.read<PermissionBloc>().add(CheckPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🔁 Triggered when app returns from background (e.g., settings)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<PermissionBloc>().add(CheckPermission());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc, PermissionState>(
      listener: (context, state) {
        if (state is PermissionPermanentlyDenied) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text(AppString.permissionRequired),
                  content: Text(
                    AppString.msgPermanentlyDenied,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black38),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppString.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        openAppSettings(); // opens system settings
                        Navigator.pop(context);
                      },
                      child: const Text(AppString.openSettings),
                    ),
                  ],
                ),
          );
        } else if (state is PermissionGranted) {
          context.go(AppRoutes.photos);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.padding40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.icPhotos,
                    width: AppDimens.dimen123,
                  ),
                  const SizedBox(height: AppDimens.space42),
                  Text(
                    AppString.requirePermission,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppDimens.space8),
                  Text(
                    AppString.msgPermission,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppDimens.space42),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<PermissionBloc>().add(RequestPermission());
                      },
                      child: const Text(AppString.grantPermission),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
