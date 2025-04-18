
class SplashState {
  final bool? isGranted;

  const SplashState({this.isGranted});

  SplashState copyWith({bool? isGranted}) {
    return SplashState(isGranted: isGranted ?? this.isGranted);
  }
}