import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        if (state is AppStatesLoaded) {
          return state.task.isNotEmpty
              ? taskBuilder(tasks: state.task, bottomColor: Colors.grey)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.close,
                        size: 100.0,
                        color: Colors.grey,
                      ),
                      Text(
                        'No Done Tasks Yet',
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
