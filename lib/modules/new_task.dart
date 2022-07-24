import 'package:flutter/material.dart';
import 'package:todo_flutter_app/shared/component/components.dart';
import 'package:todo_flutter_app/shared/component/constans.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ListView.separated(
    //   itemBuilder: (context, index) {
    //     final task = tasks[index];
    //     return buildTaskItem(task);
    //   },
    //   separatorBuilder: (context, index) {
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 10),
    //       child: Container(width: double.infinity, height: 1, color: Colors.grey[400]),
    //     );
    //   },
    //   itemCount: tasks.length,
    // );
    return const Center(
      child: Text('Ahmed'),
    );
  }
}
