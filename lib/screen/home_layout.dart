import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp2/bloc.dart';
import 'package:todoapp2/cubit/cubit.dart';
import 'package:todoapp2/cubit/navigation_cubit.dart';
import 'package:todoapp2/cubit/states.dart';
import 'package:todoapp2/screen/done_task/done_task_screen.dart';
import 'package:todoapp2/screen/new_task/new_task_screen.dart';

import '../components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    super.initState();
    AppBloc.taskBloc.createDatabase();
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final timeController = TextEditingController();

  final dateController = TextEditingController();

  List<Widget> screen = [
    NewTaskScreen(),
    DoneTaskScreen(),
  ];
  List<String> titles = [
    'Now Tasks',
    'Done Tasks',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return BlocBuilder<NavigationCubit, int>(
          builder: (context, screenIndex) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  titles[screenIndex],
                ),
              ),
              body: screen[screenIndex],
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    AppBloc.taskBloc.insertToDatabase(
                      titleController.text,
                      descriptionController.text,
                      timeController.text,
                      dateController.text,
                    );
                    Navigator.pop(context);
                    titleController.clear();
                    descriptionController.clear();
                    timeController.clear();
                    dateController.clear();
                  } else {
                    scaffoldKey.currentState?.showBottomSheet(
                      (context) => Container(
                        color: Colors.grey[100],
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormFiled(
                                controller: titleController,
                                type: TextInputType.text,
                                label: 'task title',
                                prefix: Icons.title,
                                onTap: () {},
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'task title is empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              defaultFormFiled(
                                controller: descriptionController,
                                type: TextInputType.text,
                                label: 'Description',
                                prefix: Icons.description,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'description  is empty';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then((value) {
                                    timeController.text =
                                        value!.format(context).toString();
                                  });
                                },
                                child: defaultFormFiled(
                                  enabled: false,
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  label: 'task time',
                                  prefix: Icons.watch_later_outlined,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'task time is empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(3303),
                                  ).then((value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value!);
                                  });
                                },
                                child: defaultFormFiled(
                                  enabled: false,
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  label: 'task date',
                                  prefix: Icons.calendar_month_outlined,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'date is empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 30.0,
                    );
                    //     .closed
                    //     .then((value) {
                    //   AppBloc.taskBloc.changeBottomSheetState(
                    //     isShow: false,
                    //     icon: Icons.edit,
                    //   );
                    // });
                    // AppBloc.taskBloc.changeBottomSheetState(
                    //   isShow: true,
                    //   icon: Icons.add,
                    // );
                  }
                },
                child: const Icon(
                  Icons.add,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: AppBloc.navigationCubit.currentIndex,
                onTap: (index) {
                  AppBloc.navigationCubit.changeScreen(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), label: 'Task'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.task_alt), label: 'Done'),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }
}
