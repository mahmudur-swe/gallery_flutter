import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionCubit extends Cubit<Set<String>> {
  SelectionCubit() : super({});

  void toggle(String id) {
    final current = Set<String>.from(state);
    current.contains(id) ? current.remove(id) : current.add(id);
    emit(current);
  }

  bool isSelected(String id) => state.contains(id);
}