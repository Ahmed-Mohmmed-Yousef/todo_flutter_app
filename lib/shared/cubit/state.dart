part of 'cubit.dart';

@immutable
abstract class CubitState {}

class CubitInitial extends CubitState {}


abstract class AppState {}

class AppInitialState extends AppState {}

class AppChangeBottomNavBarState extends AppState {}

class AppCreateDatabaseState extends AppState {}

class AppGetDatabaseLoadingState extends AppState {}

class AppUpdateDatabaseLoadingState extends AppState {}

class AppDeleteDatabaseLoadingState extends AppState {}

class AppGetDatabaseState extends AppState {}

class AppInserteDatabaseState extends AppState {}

class AppChangeBottomSheetState extends AppState {
  final bool isOpen;

  AppChangeBottomSheetState(this.isOpen);
}

