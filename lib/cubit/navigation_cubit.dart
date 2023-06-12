import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
  int currentIndex = 0;

  changeScreen(int index) {
    currentIndex = index;
    emit(index);
  }
}
