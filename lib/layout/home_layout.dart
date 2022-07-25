import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_flutter_app/modules/archive_task.dart';
import 'package:todo_flutter_app/modules/done_task.dart';
import 'package:todo_flutter_app/modules/new_task.dart';
import 'package:todo_flutter_app/shared/component/components.dart';
import 'package:todo_flutter_app/shared/component/constans.dart';
import 'package:todo_flutter_app/shared/cubit/cubit.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKay = GlobalKey<ScaffoldState>();
  final formKay = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          if (state is AppInserteDatabaseState) {
            print('state is AppInserteDatabaseState');
            cubit.getDataFromDatabase(cubit.database);
          }

          if (state is AppInserteDatabaseState) {
            Navigator.of(context).pop();
          }
        },
        builder: (BuildContext context, Object? state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKay,
            appBar: AppBar(
              title: Text(cubit.getTitle()),
            ),
            body: state is AppGetDatabaseLoadingState
                ? const Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () => openBottomSheet(cubit),
              child: Icon(cubit.isBottomSheetOpened ? Icons.add : Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archive")
              ],
              onTap: (value) => cubit.setCurrentIndex(value),
            ),
            // bottomSheet: bottomSheet(),
          );
        },
      ),
    );
  }

  void openBottomSheet(AppCubit cubit) {
    if (cubit.isBottomSheetOpened) {
      if (formKay.currentState!.validate()) {
        cubit.isBottomSheetOpened = false;
        cubit.insertToDatabsed(
          title: titleController.text,
          date: dateController.text,
          time: timeController.text,
        );
      }
    } else {
      cubit.isBottomSheetOpened = true;
      // setState(() {});
      scaffoldKay.currentState!
          .showBottomSheet(
            (context) => bottomSheet(context),
            elevation: 15.0,
          )
          .closed
          .then((value) {
        cubit.isBottomSheetOpened = false;
        // setState(() {});
      });
    }
  }

  Container bottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKay,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefualtTextField(
              controller: titleController,
              icon: Icons.text_fields,
              title: 'Title',
              validator: ((value) {
                if (value!.isEmpty) return "Date can not be empty";
                return null;
              }),
            ),
            const SizedBox(
              height: 15,
            ),
            DefualtTextField(
              controller: timeController,
              icon: Icons.alarm,
              title: 'Task time',
              validator: ((value) {
                print("Date id $value");
                if (value!.isEmpty) return "Time can not be empty";
                return null;
              }),
              readOnly: true,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  timeController.text = pickedTime.format(context).toString();
                } else {
                  print("Date is not selected");
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            DefualtTextField(
              controller: dateController,
              icon: Icons.calendar_today,
              title: 'Task date',
              validator: ((value) {
                print("Date id $value");
                if (value!.isEmpty) return "Date can not be empty";
                return null;
              }),
              readOnly: true,
              onTap: () async {
                DateTime? pickedTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050));
                if (pickedTime != null) {
                  dateController.text = DateFormat.yMMMd()
                      .format(pickedTime)
                      .toString(); //.toString();
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
