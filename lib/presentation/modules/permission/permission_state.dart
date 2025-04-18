
import 'package:equatable/equatable.dart';

abstract class PermissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {}

class PermissionGranted extends PermissionState {}

class PermissionDenied extends PermissionState {}

class PermissionPermanentlyDenied extends PermissionState {}
