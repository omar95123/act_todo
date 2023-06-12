import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp2/bloc.dart';

import '../../components.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        if (state is AppStatesLoaded) {
          return AppBloc.taskBloc.newTask.isNotEmpty
              ? taskBuilder(
                  tasks: AppBloc.taskBloc.newTask, bottomColor: Colors.grey)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.menu,
                        size: 100.0,
                        color: Colors.grey,
                      ),
                      Text(
                        'No Tasks Yet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }
}
