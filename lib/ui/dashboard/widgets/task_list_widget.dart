import 'package:flutter/material.dart';

import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/ui/dashboard/widgets/task_item.dart';

class TaskList extends StatelessWidget {
 final BuildContext parentContext;
  final String taskType;
  final List<TaskDataItem> taskArrayList;
  const TaskList({
    Key? key,
    required this.parentContext,
    required this.taskType,
    required this.taskArrayList,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final TaskDataItem taskModel = taskArrayList[index];
        return TaskListItem(
          parentContext: parentContext,
          taskModel: taskModel,
          index: index,
          taskType: taskType,
        );
      },
      itemCount: taskArrayList.length,
    );
  }
}
