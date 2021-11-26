import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/core/task_notifier.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/widgets/no_task_data.dart';
import 'package:velocity_x/velocity_x.dart';

import '../dashboard/widgets/task_list_widget.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    Constant.configLoading();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: MyTheme.darkBlusishColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: MyTheme.primaryColor),
        title: Strings.archivetasklist.text.bold
            .textStyle(TextStyle(color: MyTheme.primaryColor))
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Consumer<TaskNotifier>(
              builder: (context, value, child) =>
                  value.allArchiveTaskList.isNotEmpty
                      ? TaskList(
                          parentContext: context,
                              taskType: TaskTypeEnum.archive,
                              taskArrayList: value.allArchiveTaskList)
                          .expand()
                      : noTaskDataWidget(
                              context,
                              Strings.noarchivedatafound,
                              Strings.yourarchivetaskempty,
                              AppAssets.nocompletetaskImg,
                              MediaQuery.of(context).size.height / 2)
                          .centered()
                          .expand(),
            ),
          ],
        ),
      ),
    );
  }
}
