import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:intl/intl.dart';
import 'package:todo_app/auth/database/data_store.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:flutter/material.dart';

class TaskNotifier extends ChangeNotifier {
  TaskNotifier() {
    init();
  }
  User? user;
  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        if (filterDateTimeStamp == 0) {
          getCurrentDate();
        }
        String userid = FirebaseAuth.instance.currentUser!.uid;
        usersSubscription = FirebaseFirestore.instance
            .collection(Constant.tbluser)
            .where(Constant.userid,
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .listen((value) {
          QuerySnapshot<Map<String, dynamic>> snapshot = value;
          allTask = <TaskDataItem>[];
          value.docs.forEach((element) {
            Map<String, dynamic> data = element.data();

            if (element.data()[Constant.userid] ==
                FirebaseAuth.instance.currentUser!.uid) {
              Constant.fullname = element.data()[Constant.name];
              Constant.emailPref = element.data()[Constant.email];
              Constant.profileImageUrl = "";

              saveUserData(
                  name: element.data()[Constant.name],
                  email: element.data()[Constant.email],
                  logintype: element.data()[Constant.loginType],
                  isuserlogged: true,
                  facebookid: element.data()["fb_id"],
                  profileurl: element.data()[Constant.userProfileUrl]);
              Constant.initUserData();
            }
          });
          notifyListeners();
        });

        toDoSubscription = FirebaseFirestore.instance
            .collection(Constant.tblTaskList)
            .where(Constant.userid,
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where(Constant.date, isEqualTo: filterDateTimeStamp)
            .snapshots()
            .listen((value) {
          QuerySnapshot<Map<String, dynamic>> snapshot = value;
          allTask = <TaskDataItem>[];
          value.docs.forEach((element) {
            Map<String, dynamic> data = element.data();
            if (element.data()[Constant.taskSelectDate] ==
                filterDateTimeStamp) {
              allTask.add(TaskDataItem(
                  // taskid: element.id,
                  taskid: element.data()[Constant.taskid],
                  taskTitle: element.data()[Constant.tasktitle],
                  taskDesc: element.data()[Constant.taskdesc],
                  selectDateMiliSec: element.data()[Constant.taskSelectDate],
                  createdTimeStamp: element.data()[Constant.createdTimestamp],
                  updatedTimeStamp: element.data()[Constant.updatedTimestamp],
                  priorityType: element.data()[Constant.priority],
                  isBookmark: element.data()[Constant.isbookmark],
                  isComplete: element.data()[Constant.iscomplete],
                  firebaseDocumentId: element.id));
            }
          });
          notifyListeners();
        });

        archiveTaskSubscription = FirebaseFirestore.instance
            .collection(Constant.tblArchiveTaskList)
            .where(Constant.userid,
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .listen((value) {
          QuerySnapshot<Map<String, dynamic>> snapshot = value;
          archiveTaskList = <TaskDataItem>[];
          value.docs.forEach((element) {
            archiveTaskList.add(TaskDataItem(
                // taskid: element.id,
                taskid: element.data()[Constant.taskid],
                taskTitle: element.data()[Constant.tasktitle],
                taskDesc: element.data()[Constant.taskdesc],
                selectDateMiliSec: element.data()[Constant.taskSelectDate],
                createdTimeStamp: element.data()[Constant.createdTimestamp],
                updatedTimeStamp: element.data()[Constant.updatedTimestamp],
                priorityType: element.data()[Constant.priority],
                isBookmark: element.data()[Constant.isbookmark],
                isComplete: element.data()[Constant.iscomplete],
                firebaseDocumentId: element.id));
          });
          notifyListeners();
        });

        deletedTaskSubscription = FirebaseFirestore.instance
            .collection(Constant.tblDeletedTaskList)
            .where(Constant.userid,
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .listen((value) {
          QuerySnapshot<Map<String, dynamic>> snapshot = value;
          deletedTaskList = <TaskDataItem>[];
          value.docs.forEach((element) {
            deletedTaskList.add(TaskDataItem(
                // taskid: element.id,
                taskid: element.data()[Constant.taskid],
                taskTitle: element.data()[Constant.tasktitle],
                taskDesc: element.data()[Constant.taskdesc],
                selectDateMiliSec: element.data()[Constant.taskSelectDate],
                createdTimeStamp: element.data()[Constant.createdTimestamp],
                updatedTimeStamp: element.data()[Constant.updatedTimestamp],
                priorityType: element.data()[Constant.priority],
                isBookmark: element.data()[Constant.isbookmark],
                isComplete: element.data()[Constant.iscomplete],
                firebaseDocumentId: element.id));
          });
          notifyListeners();
        });
      }
    });
  }

  void callnotifyListeners() {
    notifyListeners();
  }

  List<TaskDataItem> allTask = <TaskDataItem>[];

  List<TaskDataItem> deletedTask = <TaskDataItem>[];
  List<TaskDataItem> archiveTaskList = <TaskDataItem>[];
  List<TaskDataItem> deletedTaskList = <TaskDataItem>[];
  List<TaskDataItem> get allTaskList => allTask;

  List<TaskDataItem> get allArchiveTaskList => archiveTaskList;
  List<TaskDataItem> get allDeletedTaskList => deletedTaskList;

  UnmodifiableListView<TaskDataItem> get completedTaskList =>
      UnmodifiableListView(allTask.where((element) => element.isComplete));
  UnmodifiableListView<TaskDataItem> get inCompletedTaskList =>
      UnmodifiableListView(allTask.where((element) => !element.isComplete));

  UnmodifiableListView<TaskDataItem> get favouriteTaskList =>
      UnmodifiableListView(allTask.where((element) => element.isBookmark));

  Future<DocumentReference> addTask(TaskDataItem item) {
    databaseStore.firebaseInit();

    CollectionReference listCollection =
        FirebaseFirestore.instance.collection(Constant.tblTaskList);

    Map<String, dynamic> map = HashMap();
    map.addAll(<String, dynamic>{
      Constant.taskid: item.taskid,
      Constant.tasktitle: item.getTaskName,
      Constant.taskdesc: item.getTaskDesc,
      Constant.taskSelectDate: item.getSelectDate,
      Constant.createdTimestamp: DateTime.now().millisecondsSinceEpoch,
      Constant.updatedTimestamp: 0,
      Constant.priority: item.getpriorityType,
      Constant.iscomplete: item.getIsComplete,
      Constant.isbookmark: item.getIsBookmark,
      Constant.userid: FirebaseAuth.instance.currentUser!.uid,
    });
    return listCollection.add(map);
  }

  Future<void> updateTask(int index, TaskDataItem item) async {
    databaseStore.firebaseInit();

    CollectionReference listCollection =
        FirebaseFirestore.instance.collection(Constant.tblTaskList);
    return await listCollection.doc(item.taskid).update({
      Constant.taskid: item.taskid,
      Constant.tasktitle: item.getTaskName,
      Constant.taskdesc: item.getTaskDesc,
      Constant.taskSelectDate: item.getSelectDate,
      Constant.updatedTimestamp: DateTime.now().millisecondsSinceEpoch,
      Constant.priority: item.getpriorityType,
      Constant.iscomplete: item.getIsComplete,
      Constant.isbookmark: item.getIsBookmark,
      Constant.userid: FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> removeTask(TaskDataItem item, String taskType) async {
    databaseStore.firebaseInit();

    if (taskType == TaskTypeEnum.all ||
        taskType == TaskTypeEnum.complete ||
        taskType == TaskTypeEnum.incomplete) {
      CollectionReference listCollection =
          FirebaseFirestore.instance.collection(Constant.tblTaskList);
      // return listCollection.doc(item.taskid).delete();
      return listCollection.doc(item.firebaseDocumentId).delete();
    } else if (taskType == TaskTypeEnum.archive) {
      CollectionReference listCollection =
          FirebaseFirestore.instance.collection(Constant.tblArchiveTaskList);
      return listCollection.doc(item.firebaseDocumentId).delete();
    }
  }

  Future<DocumentReference> moveToDeletedTask(TaskDataItem item) {
    databaseStore.firebaseInit();

    CollectionReference listCollection =
        FirebaseFirestore.instance.collection(Constant.tblDeletedTaskList);
    return listCollection.add(<String, dynamic>{
      Constant.taskid: item.taskid,
      Constant.tasktitle: item.getTaskName,
      Constant.taskdesc: item.getTaskDesc,
      Constant.taskSelectDate: item.getSelectDate,
      Constant.createdTimestamp: item.createdTimeStamp,
      Constant.updatedTimestamp: item.updatedTimeStamp,
      Constant.priority: item.getpriorityType,
      Constant.iscomplete: item.getIsComplete,
      Constant.isbookmark: item.getIsBookmark,
      Constant.userid: FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<DocumentReference> archiveTask(TaskDataItem item) {
    databaseStore.firebaseInit();

    CollectionReference listCollection =
        FirebaseFirestore.instance.collection(Constant.tblArchiveTaskList);
    return listCollection.add(<String, dynamic>{
      Constant.taskid: item.taskid,
      Constant.tasktitle: item.getTaskName,
      Constant.taskdesc: item.getTaskDesc,
      Constant.taskSelectDate: item.getSelectDate,
      Constant.createdTimestamp: item.createdTimeStamp,
      Constant.updatedTimestamp: item.updatedTimeStamp,
      Constant.priority: item.getpriorityType,
      Constant.iscomplete: item.getIsComplete,
      Constant.isbookmark: item.getIsBookmark,
      Constant.userid: FirebaseAuth.instance.currentUser!.uid,
    });
  }

  TaskDataItem taskItem(int index) => allTask[index];

  final DatabaseStore databaseStore = DatabaseStore();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUserToFireStore(String name, String email, String logintype,
      String fbId, String pictureProfile) {
    databaseStore
        .addUserToFireStore(name, email, logintype, fbId, pictureProfile)
        .then((value) {
      notifyListeners();
    });
  }

  DateTime dateTime = Constant.dateTime;
  DateFormat dateFormat = Constant.dateFormat;
  String filterDate = "";
  int filterDateTimeStamp = 0;
  String get filterDate1 => filterDate;
  // getToday Date
  Future<String> getCurrentDate() async {
    dateTime = DateTime.now();
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    filterDate = dateFormat.format(dateTime);
    filterDateTimeStamp = dateTime.millisecondsSinceEpoch;
    return filterDate;
  }

  // get Next Day Date
  Future<DateTime> getNextDate() async {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
    filterDate = dateFormat.format(dateTime);
    filterDateTimeStamp = dateTime.millisecondsSinceEpoch;
    notifyListeners();
    return dateTime;
  }

  // get Previous Day Date
  Future<DateTime> getPreviousDate() async {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
    filterDate = dateFormat.format(dateTime);
    filterDateTimeStamp = dateTime.millisecondsSinceEpoch;
    notifyListeners();
    return dateTime;
  }

  // get Previous Day Date
  Future<DateTime> searchByFilterDate(DateTime datetime) async {
    dateTime = DateTime(datetime.year, datetime.month, datetime.day);
    filterDate = dateFormat.format(dateTime);
    filterDateTimeStamp = dateTime.millisecondsSinceEpoch;
    notifyListeners();
    return datetime;
  }

  StreamSubscription<QuerySnapshot>? usersSubscription;
  StreamSubscription<QuerySnapshot>? toDoSubscription;
  StreamSubscription<QuerySnapshot>? archiveTaskSubscription;
  StreamSubscription<QuerySnapshot>? deletedTaskSubscription;
  @override
  void dispose() {
    super.dispose();
    usersSubscription!.cancel();
    toDoSubscription!.cancel();
    archiveTaskSubscription!.cancel();
    deletedTaskSubscription!.cancel();
  }
}
