import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_event.dart';
import 'package:gallery_flutter/presentation/modules/permission/bloc/permission_state.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/services/permission_service.dart';



class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {

  final PermissionService permissionService;

  PermissionBloc(this.permissionService) : super(PermissionInitial()) {
    on<CheckPermission>((event, emit) async {
      final status = await permissionService.isMediaPermissionGranted();

      if (status) {
        emit(PermissionGranted());
        // Optionally: load gallery here
      } else {
        emit(PermissionDenied());
      }
    });

    on<RequestPermission>((event, emit) async {
      final status = await permissionService.requestMediaPermission();

      if (status.isGranted) {
        emit(PermissionGranted());
      } else if (status.isPermanentlyDenied) {
        emit(PermissionPermanentlyDenied());
      } else {
        emit(PermissionDenied());
      }
    });
  }
}
