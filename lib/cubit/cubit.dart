import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp2/cubit/states.dart';
import 'package:todoapp2/model/model.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  late Database database;
  List<TaskModel> newTask = [];
  List<TaskModel> doneTask = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE task (id INTEGER PRIMARY KEY , title TEXT , description TEXT , time TEXT , date TEXT, status TEXT)')
            .then((value) {})
            .catchError((error) {});
      },
      onOpen: (database) {
        getDatabaseFromDatabase(database);
        emit(AppStatesLoaded(newTask));
        //emit(AppStatesLoaded(doneTask));
      },
    ).then((value) {
      database = value;
    });
  }

  insertToDatabase(
    String title,
    String description,
    String time,
    String date,
  ) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO task (title , description , time , date , status) VALUES ("$title","$description","$time","$date","new")',
      )
          .then((value) {
        TaskModel(value,
            title: title, date: date, description: description, time: time);
        newTask.add(TaskModel(value,
            title: title, date: date, description: description, time: time));
        emit(AppStatesLoaded(newTask));
        //getDatabaseFromDatabase(database);
      }).catchError((error) {});
    });
  }

  void getDatabaseFromDatabase(database) async {
    newTask.clear();
    doneTask.clear();
    database.rawQuery('SELECT * FROM task').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTask.add(TaskModel(element['id'],
              title: element['title'],
              date: element['date'],
              description: element['description'],
              time: element['time']));
        } else {
          doneTask.add(TaskModel(element['id'],
              title: element['title'],
              date: element['date'],
              description: element['description'],
              time: element['time']));
        }
      });
    });
    emit(AppStatesLoaded(newTask));
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE task SET status = ? WHERE id = ?', [
      status,
      id,
    ]).then((value) {
      doneTask.add(newTask.firstWhere((task) => task.id == id));
      newTask.removeWhere((task) => task.id == id);
      emit(AppStatesLoaded(newTask));
      //getDatabaseFromDatabase(database);
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM task WHERE id = ?', [
      id,
    ]).then((value) {
      getDatabaseFromDatabase(database);
      // emit(AppStatesLoaded();
    });
  }

  loadDone() => emit(AppStatesLoaded(doneTask));
  loadNew() => emit(AppStatesLoaded(newTask));

  // bool isBottomSheetShown = false;
  // IconData fabIcon = Icons.edit;
  //
  // void changeBottomSheetState({
  //   required bool isShow,
  //   required IconData icon,
  // }) {
  //   isBottomSheetShown = isShow;
  //   fabIcon = icon;
  //   emit(AppChangeBottomSheetState());
  // }
}
