import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/core/task_notifier.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/ui/dashboard/dashboard_screen.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:todo_app/common/constant.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/bottomsheet/create_task_btn.dart';

void createTaskBottomSheetModal(
    BuildContext context, bool isAdd, int indexOfTaskList, Color bgColor) {
  dateTime = DateTime.now();
  var space = const SizedBox(height: 20);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TaskDataItem? taskDataItem = !isAdd
      ? Provider.of<TaskNotifier>(context, listen: false)
          .taskItem(indexOfTaskList)
      : null;
  selectedPriority = !isAdd ? taskDataItem!.getpriorityType : "";
  if (!isAdd) {
    dateTime = DateTime.fromMillisecondsSinceEpoch(taskDataItem!.getSelectDate);
    selectedDate = dateFormat.format(dateTime);
  } else {
    selectedDate = dateFormat.format(dateTime);
  }

  final taskNameController =
      TextEditingController(text: !isAdd ? taskDataItem!.getTaskName : "");

  showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black.withAlpha(30),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
                color: bgColor,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 20,
                      MediaQuery.of(context).viewInsets.bottom + 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        controller: taskNameController,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        obscureText: false,
                        enabled: true,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(2.0),
                            isDense: false,
                            hintText: Strings.taskname,
                            hintStyle: TextStyle(color: Colors.white),
                            errorStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Strings.validatetaskname;
                          }
                        },
                      ),
                      const EditableTaskDate(),
                      const SizedBox(height: 40),
                      "Priority"
                          .text
                          .bold
                          .textStyle(const TextStyle(fontSize: 14))
                          .white
                          .make(),
                      const SizedBox(height: 10),
                      const RadioGroup(),
                      space,
                      Center(
                        child: CreateTaskButton(
                          bgColor: Colors.white,
                          textColor: MyTheme.primaryColor,
                          iconTintColor: MyTheme.primaryColor,
                          shadowColor: Colors.white,
                          title:
                              isAdd ? Strings.createtask : Strings.updatetask,
                          onTapCallBack: () {
                            if (isAdd) {
                              if (!formKey.currentState!.validate()) {
                                VxToast.show(context,
                                    msg: Strings.validatetaskname,
                                    position: VxToastPosition.center);
                                return;
                              } else if (selectedDate.isEmptyOrNull) {
                                VxToast.show(context,
                                    msg: Strings.validateselectdate,
                                    position: VxToastPosition.center);
                                return;
                              } else if (selectedPriority.isEmptyOrNull) {
                                VxToast.show(context,
                                    msg: Strings.validatepriority,
                                    position: VxToastPosition.center);
                                return;
                              }

                              if (selectDateMiliSec == 0) {
                                dateTime = DateTime.now();
                                dateTime = DateTime(dateTime.year,
                                    dateTime.month, dateTime.day);
                                selectDateMiliSec =
                                    dateTime.millisecondsSinceEpoch;
                              }
                              TaskDataItem taskDataitem = TaskDataItem(
                                  taskTitle: taskNameController.text,
                                  taskDesc: "",
                                  priorityType: selectedPriority,
                                  selectDateMiliSec: selectDateMiliSec,
                                  isBookmark: false,
                                  isComplete: false);

                              Provider.of<TaskNotifier>(context, listen: false)
                                  .addTask(taskDataitem)
                                  .then((value) {
                                taskDataitem.taskid = value.id;

                                Provider.of<TaskNotifier>(context,
                                        listen: false)
                                    .updateTask(-1, taskDataitem);

                                Provider.of<TaskNotifier>(context,
                                        listen: false)
                                    .searchByFilterDate(dashDateTime)
                                    .then((value) {
                                  Provider.of<TaskNotifier>(context,
                                          listen: false)
                                      .init();
                                });
                                // TaskNotifier();
                                if (value != null) {
                                  Constant.showSnackBar(
                                      context,
                                      TaskActionTypeEnum.add,
                                      Strings.taskaddsuccess);
                                }
                              });
                            } else {
                              taskDataItem!.setTaskName =
                                  taskNameController.text;
                              taskDataItem.setSelectDate = selectDateMiliSec;
                              taskDataItem.setpriorityType = selectedPriority;
                              Provider.of<TaskNotifier>(context, listen: false)
                                  .updateTask(indexOfTaskList, taskDataItem)
                                  .then((value) {
                                Constant.showSnackBar(
                                    context,
                                    TaskActionTypeEnum.update,
                                    Strings.taskupdateuccess);

                                Provider.of<TaskNotifier>(context,
                                        listen: false)
                                    .searchByFilterDate(dashDateTime)
                                    .then((value) {
                                  Provider.of<TaskNotifier>(context,
                                          listen: false)
                                      .init();
                                });
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                )),
          ),
        );
      });
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({Key? key}) : super(key: key);

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

String selectedPriority = "";

class _RadioGroupState extends State<RadioGroup> {
  @override
  void initState() {
    super.initState();
  }

  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProrityButton(
          buttonTitle: PriorityEnum.high,
          isSelected: selectedPriority == PriorityEnum.high ? true : false,
          onCustomTap: () {
            setState(() {
              selectedPriority = PriorityEnum.high;
            });
          },
        ),
        ProrityButton(
          buttonTitle: PriorityEnum.medium,
          isSelected: selectedPriority == PriorityEnum.medium ? true : false,
          onCustomTap: () {
            setState(() {
              selectedPriority = PriorityEnum.medium;
            });
          },
        ),
        ProrityButton(
          buttonTitle: PriorityEnum.low,
          isSelected: selectedPriority == PriorityEnum.low ? true : false,
          onCustomTap: () {
            setState(() {
              selectedPriority = PriorityEnum.low;
            });
          },
        ),
        ProrityButton(
          buttonTitle: PriorityEnum.verylow,
          isSelected: selectedPriority == PriorityEnum.verylow ? true : false,
          onCustomTap: () {
            setState(() {
              selectedPriority = PriorityEnum.verylow;
            });
          },
        ),
      ],
    );
  }
}

int selectDateMiliSec = 0;
String selectedDate = "";
DateTime dateTime = DateTime.now();
DateFormat dateFormat = Constant.dateFormat;

// Date Widget
class EditableTaskDate extends StatefulWidget {
  const EditableTaskDate({
    Key? key,
  }) : super(key: key);

  @override
  State<EditableTaskDate> createState() => _EditableTaskDateState();
}

class _EditableTaskDateState extends State<EditableTaskDate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(height: 30);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          space,
          InkWell(
            onTap: () async {
              dateTime = DateTime.now();
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: dateTime,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2050));
              if (picked != null && picked != dateTime) {
                setState(() {
                  dateTime = picked;
                  selectedDate = dateFormat.format(dateTime);
                  selectDateMiliSec = dateTime.millisecondsSinceEpoch;
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "$selectedDate".text.white.bold.make(),
                Image.asset(AppAssets.dateIcon),
              ],
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

// Priority Button Widget
class ProrityButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onCustomTap;
  final String buttonTitle;
  const ProrityButton(
      {Key? key,
      required this.isSelected,
      required this.onCustomTap,
      required this.buttonTitle})
      : super(key: key);

  @override
  State<ProrityButton> createState() => _ProrityButtonState();
}

class _ProrityButtonState extends State<ProrityButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: widget.isSelected
            ? ElevatedButton.styleFrom(
                primary: Colors.white,
                shadowColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))
            : ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(MyTheme.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                ),
              ),
        onPressed: () {
          widget.onCustomTap.call();
        },
        child: Container(
          child: widget.buttonTitle.text.lg
              .textStyle(TextStyle(
                  color:
                      widget.isSelected ? MyTheme.primaryColor : Colors.white))
              .bold
              .center
              .make(),
        ));
  }
}
