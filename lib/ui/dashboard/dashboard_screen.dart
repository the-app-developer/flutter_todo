import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/core/task_notifier.dart';
import 'package:todo_app/drawer/nav_drawer.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/bottomsheet/create_task_bottom_sheet.dart';
import 'package:todo_app/ui/dashboard/bottomsheet/create_task_btn.dart';
import 'package:todo_app/ui/dashboard/widgets/task_tabbar.dart';
import 'package:velocity_x/velocity_x.dart';

class DashboradScreen extends StatefulWidget {
  const DashboradScreen({Key? key}) : super(key: key);

  @override
  State<DashboradScreen> createState() => _DashboradScreenState();
}

DateTime dashDateTime = DateTime.now();

class _DashboradScreenState extends State<DashboradScreen> {
  @override
  Widget build(BuildContext context) {
    Constant.configLoading();
    Constant.initUserData();
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Center(
        child: Scaffold(
          key: scaffoldKey,
          drawer: const MyDrawer(),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              alignment: Alignment.center,
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          scaffoldKey.currentState?.openDrawer();
                        },
                        child: Image.asset(AppAssets.navdrawerIcon).wh(23, 23)),
                    const SizedBox(
                      height: 20,
                    ),
                    Strings.myday.text.xl4.bold.make(),
                    const SizedBox(
                      height: 20,
                    ),
                    datePrevNextWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    TaskTabbar(
                      parentContext: context,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CreateTaskButton(
                    bgColor: MyTheme.primaryColor,
                    textColor: Colors.white,
                    iconTintColor: Colors.white,
                    shadowColor: Colors.blue,
                    title: Strings.createtask,
                    onTapCallBack: () {
                      createTaskBottomSheetModal(
                          context, true, -1, MyTheme.bgColor);
                    },
                  ),
                ).p16()
              ]),
            ),
          ),
        ),
      ),
    );
  }

  String filterDate = "";
  Widget datePrevNextWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            EasyLoading.show(status: Strings.pleasewait);
            Provider.of<TaskNotifier>(context, listen: false)
                .getPreviousDate()
                .then((value) {
              dashDateTime = value;
              Provider.of<TaskNotifier>(context, listen: false)
                  .init()
                  .then((value) {
                EasyLoading.dismiss();
              });
            });
          },
          child: Image.asset(
            AppAssets.leftArrowIcon,
            width: 20,
            height: 20,
          ),
        ),
        Consumer<TaskNotifier>(
            builder: (context, value, child) => Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: dashDateTime,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2050));
                        if (picked != null && picked != dashDateTime) {
                          setState(() {
                            dashDateTime = picked;
                            Provider.of<TaskNotifier>(context, listen: false)
                                .searchByFilterDate(dashDateTime)
                                .then((value) {
                              Provider.of<TaskNotifier>(context, listen: false)
                                  .init();
                            });
                          });
                        }
                      },
                      child: value.filterDate1.text.bold.lg.make()),
                )),
        InkWell(
          onTap: () {
            EasyLoading.show(status: Strings.pleasewait);
            Provider.of<TaskNotifier>(context, listen: false)
                .getNextDate()
                .then((value) {
              dashDateTime = value;
              Provider.of<TaskNotifier>(context, listen: false)
                  .init()
                  .then((value) {
                EasyLoading.dismiss();
              });
            });
          },
          child: Image.asset(
            AppAssets.rightArrowIcon,
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }
}
