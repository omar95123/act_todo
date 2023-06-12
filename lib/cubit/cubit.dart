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
        print('database created');
        database
            .execute(
                'CREATE TABLE task (id INTEGER PRIMARY KEY , title TEXT , description TEXT , time TEXT , date TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDatabaseFromDatabase(database);
        emit(AppStatesLoaded(newTask));
        emit(AppStatesLoaded(doneTask));

        print('database open');
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
        print('$value inserted successfully');

        getDatabaseFromDatabase(database);
      }).catchError((error) {
        print('error when insert new record ${error.toString()}');
      });
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

          emit(AppStatesLoaded(newTask));
        } else {
          doneTask.add(TaskModel(element['id'],
              title: element['title'],
              date: element['date'],
              description: element['description'],
              time: element['time']));
          print(doneTask);
        }
        print(element['status']);
        emit(AppStatesLoaded(doneTask));
      });
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE task SET status = ? WHERE id = ?', [
      status,
      id,
    ]).then((value) {
      getDatabaseFromDatabase(database);
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
