//
//
// abstract class AppStates {}
//
// class AppInitialState extends AppStates {}
//
// class AppChangeBottomNavBarState extends AppStates {}
//
// class AppCreateDateBaseState extends AppStates {}
//
// class AppGetDateBaseState extends AppStates {}
//
// class AppGetDateBaseLoadingState extends AppStates {}
//
// class DoneState extends AppStates {
//   final List<Map> doneTask;
//
//   DoneState(this.doneTask);
// }
//
// class TaskState extends AppStates {
//   final List<Map> newTask;
//
//   TaskState(this.newTask);
// }
//
// class AppInsertDateBaseState extends AppStates {
//   // final List<TaskModel> taskModel;
//   //
//   // AppInsertDateBaseState(this.taskModel);
// }
//
// class AppUpdateDateBaseState extends AppStates {}
//
// class AppDeleteDateBaseState extends AppStates {}
//
// class AppChangeBottomSheetState extends AppStates {}

import 'package:todoapp2/model/model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppStatesLoaded extends AppStates {
  final List<TaskModel> task;

  AppStatesLoaded(this.task);
}
