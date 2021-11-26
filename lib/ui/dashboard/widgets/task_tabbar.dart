import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/core/task_notifier.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/widgets/no_task_data.dart';
import 'package:todo_app/ui/dashboard/widgets/task_list_widget.dart';

class TaskTabbar extends StatefulWidget {
  final BuildContext parentContext;
  const TaskTabbar({
    Key? key,
    required this.parentContext,
  }) : super(key: key);

  @override
  _TaskTabbarState createState() => _TaskTabbarState();
}

class _TaskTabbarState extends State<TaskTabbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TaskModel taskModel = TaskModel();
    final List<TaskDataItem> allTaskList =
        Provider.of<TaskNotifier>(context, listen: true).allTaskList;

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
              indicatorWeight: 3.0,
              unselectedLabelColor: Colors.grey,
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              isScrollable: true,
              labelColor: MyTheme.primaryColor,
              indicatorColor: MyTheme.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                const Tab(text: Strings.all),
                const Tab(text: Strings.complete),
                const Tab(text: Strings.incomplete),
              ]),
          const SizedBox(
            height: 10,
          ),
          TabBarView(
            children: [
              Consumer<TaskNotifier>(
                builder: (context, value, child) => value.allTask.isNotEmpty
                    ? TaskList(
                        parentContext: widget.parentContext,
                        taskType: TaskTypeEnum.all,
                        taskArrayList: value.allTask)
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                        child: noTaskDataWidget(
                          context,
                          Strings.addtask,
                          Strings.tasklistempty,
                          AppAssets.addnewtaskIcon,
                          MediaQuery.of(context).size.height / 3.0,
                        ).centered(),
                      ),
              ),
              Consumer<TaskNotifier>(
                builder: (context, value, child) =>
                    value.completedTaskList.isNotEmpty
                        ? TaskList(
                            parentContext: widget.parentContext,
                            taskType: TaskTypeEnum.complete,
                            taskArrayList: value.completedTaskList)
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                            child: noTaskDataWidget(
                              context,
                              Strings.nocompletetask,
                              Strings.startworkingsometask,
                              AppAssets.nocompletetaskImg,
                              MediaQuery.of(context).size.height / 3.0,
                            ).centered(),
                          ),
              ),
              Consumer<TaskNotifier>(
                builder: (context, value, child) =>
                    value.inCompletedTaskList.isNotEmpty
                        ? TaskList(
                            parentContext: widget.parentContext,
                            taskType: TaskTypeEnum.incomplete,
                            taskArrayList: value.inCompletedTaskList)
                        : Padding(
                         padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
                          child: noTaskDataWidget(
                              context,
                              Strings.allclear,
                              Strings.lookatyoucompletealltask,
                              AppAssets.incompletetaskImg,
                              MediaQuery.of(context).size.height / 3.0,
                            ).centered(),
                        ),
              ),
            ],
          ).expand(),
        ],
      ).expand(),
    );
  }
}
