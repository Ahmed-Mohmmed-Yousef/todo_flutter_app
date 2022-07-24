import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_flutter_app/modules/archive_task.dart';
import 'package:todo_flutter_app/modules/done_task.dart';
import 'package:todo_flutter_app/modules/new_task.dart';

part 'cubit_state.dart';

class CubitCubit extends Cubit<CubitState> {
  CubitCubit() : super(CubitInitial());
}

class AppCubit extends Cubit<AppState> {
  AppCubit(): super(AppInitialState());
  
  static AppCubit get(BuildContext context) => BlocProvider.of(context);   

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
}