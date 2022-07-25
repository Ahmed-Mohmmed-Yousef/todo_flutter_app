import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_flutter_app/modules/archive_task.dart';
import 'package:todo_flutter_app/modules/done_task.dart';
import 'package:todo_flutter_app/modules/new_task.dart';

part 'state.dart';

class CubitCubit extends Cubit<CubitState> {
  CubitCubit() : super(CubitInitial());
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  List<Map<String, Object?>> newTasks = [];
  List<Map<String, Object?>> doneTasks = [];
  List<Map<String, Object?>> archiveTasks = [];
  

  late Database database;

  bool _isBottomSheetOpened = false;

  bool get isBottomSheetOpened => _isBottomSheetOpened;

  set isBottomSheetOpened(bool isBottomSheetOpened) {
    _isBottomSheetOpened = isBottomSheetOpened;
    emit(AppChangeBottomSheetState(isBottomSheetOpened));
  }

  final List<Widget> screens = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  final List<String> titles = const [
    'New Tasks',
    "Done Tasks",
    'Archive Tasks',
  ];

  int currentIndex = 0;

  void setCurrentIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  String getTitle() {
    return titles[currentIndex];
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('Databse created');
        var exc = db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)');
        exc.then((value) {
          print('Table created');
        }).catchError((error) {
          print('error occure ${error.toString()}');
        });
      },
      onOpen: ((database) {
        print('Database opened');
        getDataFromDatabase(database);
      }),
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabsed(
      {required String title, required String date, required String time}) {
    Map<String, Object?> values = {
      "title": title,
      "date": date,
      "time": time,
      "status": 'New',
    };

    database.insert('tasks', values).then((value) {
      print('$value inserted succ');
      emit(AppInserteDatabaseState());
    });
  }

  void getDataFromDatabase(Database database) {
    emit(AppGetDatabaseLoadingState());
    database.query('tasks').then((value) {
      newTasks = value.where((element) => element['status'] == 'New').toList();
      doneTasks = value.where((element) => element['status'] == 'done').toList();
      archiveTasks = value.where((element) => element['status'] == 'archive').toList();
      emit(AppGetDatabaseState());
    });
  }

  void updateTask(String status, int taskId) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        [status, taskId]).then((value) {
      emit(AppUpdateDatabaseLoadingState());
    });
  }

  void deletTask(int id) {
    database.delete('tasks', where: 'id = ?', whereArgs: [id]).then((value) {
      emit(AppDeleteDatabaseLoadingState());
    }).catchError((error) => print('Error on delete row id = $id, error : ${error.toString()}'));
  }

}
