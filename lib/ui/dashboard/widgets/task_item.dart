import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/dashboard/dashboard_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/core/task_notifier.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/bottomsheet/create_task_bottom_sheet.dart';

class TaskListItem extends StatefulWidget {
  final BuildContext parentContext;
  final TaskDataItem taskModel;
  final int index;
  final String taskType;
  const TaskListItem({
    Key? key,
    required this.parentContext,
    required this.taskModel,
    required this.index,
    required this.taskType,
  }) : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TaskDataItem taskModel = widget.taskModel;
    Color lineColor =
        taskModel.isComplete ? MyTheme.greenColor : MyTheme.redColor;
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: VxBox(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                widget.taskType == TaskTypeEnum.archive &&
                        widget.taskType == TaskTypeEnum.favourite
                    ? null
                    : setState(() {
                        bool b = widget.taskModel.isComplete ? false : true;
                        widget.taskModel.isSelected = b;
                        widget.taskModel.isComplete = b;

                        Provider.of<TaskNotifier>(context, listen: false)
                            .updateTask(widget.index, widget.taskModel)
                            .then((value) {
                          Constant.showSnackBar(
                              context,
                              b
                                  ? TaskActionTypeEnum.complete
                                  : TaskActionTypeEnum.incomplete,
                              b
                                  ? Strings.taskcompletesuccess
                                  : Strings.tasknotcomplete);
                        });
                      });
              },
              child: widget.taskModel.isComplete
                  ? Image.asset(AppAssets.checkIcon).wh(25, 25)
                  : Image.asset(AppAssets.uncheckIcon).wh(25, 25),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 20,
              margin: const EdgeInsets.fromLTRB(13, 20, 13, 20),
              width: 2.5,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 7,
                    color: lineColor.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (widget.taskType == TaskTypeEnum.favourite ||
                    widget.taskType == TaskTypeEnum.archive) {
                  null;
                } else {
                  createTaskBottomSheetModal(widget.parentContext, false,
                      widget.index, MyTheme.bgColor);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.taskModel.getTaskName.text.lg.bold
                      .textStyle(TextStyle(
                          decoration: widget.taskModel.isComplete
                              ? TextDecoration.lineThrough
                              : TextDecoration.none))
                      .maxLines(2)
                      .ellipsis
                      .make(),
                  const SizedBox(
                    height: 8,
                  ),
                  "${taskModel.getpriorityType + " priority"}"
                      .text
                      .sm
                      .bold
                      .textStyle(TextStyle(color: MyTheme.greyColor))
                      .make(),
                ],
              ),
            ).expand(),
            const SizedBox(
              width: 10,
            ),
            Visibility(
              visible: widget.taskModel.getIsBookmarkVisible ? true : false,
              child: InkWell(
                onTap: () {
                  widget.taskType == TaskTypeEnum.archive &&
                          widget.taskType == TaskTypeEnum.favourite
                      ? null
                      : setState(() {
                          bool b = widget.taskModel.isBookmark ? false : true;
                          !widget.taskModel.isBookmark
                              ? Constant.showSnackBar(
                                  context,
                                  TaskActionTypeEnum.update,
                                  Strings.addedtobookmark)
                              : Constant.showSnackBar(
                                  context,
                                  TaskActionTypeEnum.update,
                                  Strings.removedfrombookmark);
                          widget.taskModel.isBookmark = b;

                          Provider.of<TaskNotifier>(context, listen: false)
                              .updateTask(widget.index, widget.taskModel)
                              .then((value) {});
                        });
                },
                child: widget.taskModel.isBookmark
                    ? Image.asset(AppAssets.selectbookmarkIcon).wh(20, 20)
                    : Image.asset(AppAssets.deselectbookmarkIcon).wh(20, 20),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Visibility(
                visible:
                    widget.taskType != TaskTypeEnum.favourite ? true : false,
                child: InkWell(
                    onTap: () {
                      showDeleteConfirmDialog(
                          context, widget.taskType, widget.taskModel);
                    },
                    child: Image.asset(AppAssets.closeIcon).wh(18, 18))),
          ],
        ),
      )).white.roundedLg.shadowMd.outerShadowLg.make().py12(),
    );
  }
}

showDeleteConfirmDialog(
    BuildContext ctx, String taskType, TaskDataItem dataItem) {
  Widget restoreButton = TextButton(
    child: const Text(Strings.restore),
    onPressed: () {
      Provider.of<TaskNotifier>(ctx, listen: false)
          .addTask(dataItem)
          .then((value) {
        if (value != null) {
          Constant.showSnackBar(
              ctx, TaskActionTypeEnum.add, Strings.taskrestore);
          TaskNotifier();
          Provider.of<TaskNotifier>(ctx, listen: false)
              .removeTask(dataItem, taskType)
              .then((value) {});
        }
      });
      Navigator.of(ctx, rootNavigator: true).pop('dialog');
    },
  );

  Widget cancelButton = TextButton(
    child: const Text(Strings.cancel),
    onPressed: () {
      Navigator.of(ctx, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = TextButton(
    child: const Text(Strings.delete),
    onPressed: () {
      if (taskType == TaskTypeEnum.all ||
          taskType == TaskTypeEnum.complete ||
          taskType == TaskTypeEnum.incomplete) {
        // Move to archive list
        Provider.of<TaskNotifier>(ctx, listen: false)
            .archiveTask(dataItem)
            .then((value) {
          Constant.showSnackBar(
              ctx, TaskActionTypeEnum.delete, Strings.taskmovedarchieve);

          // Delete task
          Provider.of<TaskNotifier>(ctx, listen: false)
              .removeTask(dataItem, taskType)
              .then((value) {
            Constant.showSnackBar(
                ctx, TaskActionTypeEnum.delete, Strings.tasdeletesuccess);

            Provider.of<TaskNotifier>(ctx, listen: false)
                .searchByFilterDate(dashDateTime)
                .then((value) {
              Provider.of<TaskNotifier>(ctx, listen: false).init();
            });
          });
        });

        Navigator.of(ctx, rootNavigator: true).pop('dialog');
      } else if (taskType == TaskTypeEnum.archive) {
        // Delete Archive task
        // Move to deleted  list
        Provider.of<TaskNotifier>(ctx, listen: false)
            .moveToDeletedTask(dataItem)
            .then((value) {});

        Provider.of<TaskNotifier>(ctx, listen: false)
            .removeTask(dataItem, taskType)
            .then((value) {
          TaskNotifier();
          Constant.showSnackBar(ctx, TaskActionTypeEnum.delete,
              Strings.tasdeletepermanentlysuccess);
        });
        Navigator.of(ctx, rootNavigator: true).pop('dialog');
      }
    },
  );
  List<Widget> widgetList = [];
  for (int i = 0; i < 3; i++) {
    if (i == 0) {
      widgetList.add(cancelButton);
    }
    if (i == 1 && taskType == TaskTypeEnum.archive) {
      widgetList.add(restoreButton);
    }
    if (i == 2) {
      widgetList.add(continueButton);
    }
  }
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(Strings.deletealert),
    content: Text(taskType == TaskTypeEnum.archive
        ? Strings.areyousurewantdeletepermentlyselecttask
        : Strings.areyousurewantdeleteselecttask),
    actions: widgetList,
  );
  // show the dialog

  showDialog(
    context: ctx,
    builder: (ctx) {
      return alert;
    },
  );
}
