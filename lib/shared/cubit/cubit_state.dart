part of 'cubit_cubit.dart';

@immutable
abstract class CubitState {}

class CubitInitial extends CubitState {}


abstract class AppState {}

class AppInitialState extends AppState {}

class AppChangeBottomNavBarState extends AppState {}