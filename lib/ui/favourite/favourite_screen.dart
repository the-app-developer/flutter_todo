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

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    Constant.configLoading();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        iconTheme: IconThemeData(color: MyTheme.primaryColor),
        title: Strings.favouritetasklist.text.bold
            .textStyle(TextStyle(color: MyTheme.primaryColor))
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          children: [
            Consumer<TaskNotifier>(
              builder: (context, value, child) =>
                  value.favouriteTaskList.isNotEmpty
                      ? TaskList(
                        parentContext: context,
                          taskType: TaskTypeEnum.favourite,
                          taskArrayList: value.favouriteTaskList)
                      : noTaskDataWidget(
                          context,
                          Strings.nofavouritetaskfound,
                          Strings.yourfavouritetaskempty,
                          AppAssets.nocompletetaskImg,
                          MediaQuery.of(context).size.height / 2,
                        ).centered()
                          .expand(),
            ),
          ],
        ),
      ),
    );
  }
}
