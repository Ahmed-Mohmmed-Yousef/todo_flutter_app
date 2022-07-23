import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_flutter_app/modules/archive_task.dart';
import 'package:todo_flutter_app/modules/done_task.dart';
import 'package:todo_flutter_app/modules/new_task.dart';
import 'package:todo_flutter_app/shared/component/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final scaffoldKay = GlobalKey<ScaffoldState>();
  final formKay = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isBottomSheetOpened = false;

  late Database database;

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

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKay,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        automaticallyImplyLeading: false,
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => openBottomSheet(),
        child: Icon(isBottomSheetOpened ? Icons.add : Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: "Archive")
        ],
        onTap: (value) => currentIndex = value,
      ),
      // bottomSheet: bottomSheet(),
    );
  }

  void openBottomSheet() {
    if (isBottomSheetOpened) {
      if (formKay.currentState!.validate()) {
        insertToDatabsed(
          title: titleController.text,
          date: dateController.text,
          time: timeController.text,
        ).then((value) {
          print('$value was inserted in to database');
          Navigator.of(context).pop();
          print(titleController.text);
          isBottomSheetOpened = false;
          setState(() {});
        });
      }
    } else {
      isBottomSheetOpened = true;
      setState(() {});
      scaffoldKay.currentState?.showBottomSheet(
        (context) => bottomSheet(),
        enableDrag: false,
        elevation: 15.0,
        // shape: const RoundedRectangleBorder(),
        // backgroundColor: Colors.grey[400],
      );
    }
  }

  Container bottomSheet() {
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
              controller: dateController,
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
                  dateController.text = pickedTime.format(context).toString();
                } else {
                  print("Date is not selected");
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            DefualtTextField(
              controller: timeController,
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
                  timeController.text = DateFormat.yMMMd()
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

  void createDatabase() async {
    database = await openDatabase(
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
      onOpen: ((db) {
        print('Database opened');
      }),
    );
  }

  Future<int> insertToDatabsed(
      {required String title,
      required String date,
      required String time}) async {
    Map<String, Object?> values = {
      "title": title,
      "date": date,
      "time": time,
      "status": 'New',
    };

    return await database.insert('tasks', values);
  }
}
