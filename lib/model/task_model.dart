class TaskModel {
  static List<TaskDataItem> allTask = <TaskDataItem>[];

  List<TaskDataItem> get allTaskList => allTask;

  void addTask(TaskDataItem item) {
    allTask.add(item);
  }

  void updaTask(int index, TaskDataItem item) {
    allTask[index] = item;
  }

  void removeTask(TaskDataItem item) {
    allTask.remove(item);
  }

  TaskDataItem taskItem(int index) => allTask[index];
}

class TaskDataItem {
  late String taskid;
  late String taskTitle;
  late String taskDesc;
  late int selectDateMiliSec;
  late int createdTimeStamp;
  late int updatedTimeStamp;
  late String priorityType;
  late bool isSelected;
  late bool isBookmark;
  late bool isComplete;
  bool isBookmarkVisible;
  late String firebaseDocumentId;
  TaskDataItem({
    this.taskid = "",
    required this.taskTitle,
    required this.taskDesc,
    required this.selectDateMiliSec,
    this.createdTimeStamp = 0,
    this.updatedTimeStamp = 0,
    required this.priorityType,
    this.isSelected = false,
    required this.isBookmark,
    required this.isComplete,
    this.isBookmarkVisible = true,
    this.firebaseDocumentId = "",
  });
  String get getTaskName => taskTitle;

  set setTaskName(String value) {
    taskTitle = value;
  }

  String get getTaskDesc => taskDesc;

  set setTaskDesc(String value) {
    taskDesc = value;
  }

  int get getSelectDate => selectDateMiliSec;

  set setSelectDate(int value) {
    selectDateMiliSec = value;
  }

  String get getpriorityType => priorityType;

  set setpriorityType(String value) {
    priorityType = value;
  }

  bool get getIsSelected => isSelected;

  set setIsSelected(bool value) {
    isSelected = value;
  }

  bool get getIsBookmark => isBookmark;

  set setIsBookmark(bool value) {
    isBookmark = value;
  }

  bool get getIsComplete => isComplete;

  set setIsComplete(bool value) {
    isComplete = value;
  }

  bool get getIsBookmarkVisible => isBookmarkVisible;

  set setIsBookmarkVisible(bool value) {
    isBookmarkVisible = value;
  }
}
