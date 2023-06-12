import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp2/cubit/navigation_cubit.dart';

import 'cubit/cubit.dart';

class AppBloc {
  static final taskBloc = AppCubit();
  static final navigationCubit = NavigationCubit();

  static final List<BlocProvider> providers = [
    BlocProvider<AppCubit>(
      create: (context) => taskBloc,
    ),
    BlocProvider<NavigationCubit>(
      create: (context) => navigationCubit,
    ),
  ];

  static void dispose() {
    taskBloc.close();
    navigationCubit.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}
