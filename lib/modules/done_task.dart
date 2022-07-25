import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_flutter_app/shared/component/components.dart';
import 'package:todo_flutter_app/shared/cubit/cubit.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return cubit.doneTasks.isEmpty
            ? const Center(child: Text('No Tasks'))
            : ListView.separated(
                itemBuilder: (context, index) {
                  final task = cubit.doneTasks[index];
                  return buildTaskItem(task, context);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[400]),
                  );
                },
                itemCount: cubit.doneTasks.length,
              );
      },
    );
  }
}
