import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_event.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/permission_service.dart';
import '../../../../core/util/log.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final PermissionService permissionService;

  PermissionBloc(this.permissionService) : super(PermissionInitial()) {
    on<CheckPermission>((event, emit) async {
      final status = await permissionService.isMediaPermissionGranted();

      if (status) {
        emit(PermissionGranted());
      } else {
        emit(PermissionDenied());
      }
    });

    on<RequestPermission>((event, emit) async {
      final status = await permissionService.requestMediaPermission();

      if (status.isGranted) {
        Log.debug("Permission Granted");
        emit(PermissionGranted());
      } else if (status.isPermanentlyDenied) {
        Log.debug("Permission Permanently Denied");
        emit(PermissionPermanentlyDenied());
      } else {
        Log.debug("Permission Denied");
        emit(PermissionDenied());
      }
    });
  }
}
