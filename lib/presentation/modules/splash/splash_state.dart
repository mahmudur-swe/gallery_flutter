
import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool? isGranted;

  const SplashState({this.isGranted});

  SplashState copyWith({bool? isGranted}) {
    return SplashState(isGranted: isGranted ?? this.isGranted);
  }

  @override
  List<Object?> get props => [isGranted];
}