import 'package:todoapp2/model/model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppStatesLoaded extends AppStates {
  final List<TaskModel> task;

  AppStatesLoaded(this.task);
}
