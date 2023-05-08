import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/data/services/storage/repository.dart';

import '../../data/models/task.dart';

class HomeController extends GetxController {
  final TaskRepository taskRepository;

  HomeController({
    required this.taskRepository,
  });

  final tabIndex = 0.obs;
  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final task = Rx<Task?>(null);
  final tasks = <Task>[].obs;
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTask());
    debugPrint('tasks: $tasks');
    ever(tasks, (_) {
      debugPrint("shubha");
      taskRepository.writeTask(tasks);
    });
  }

  @override
  void onClose() {
    editController.dispose();
    super.onClose();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changeChipIndex(int index) {
    chipIndex.value = index;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  void changeTask(Task? selectedTask) {
    task.value = selectedTask;
  }

  bool updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containTodo(todos, title)) {
      return false;
    }
    var todo = {
      'title': title,
      'isDone': false,
    };
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIndex = tasks.indexOf(task);
    tasks[oldIndex] = newTask;
    tasks.refresh();
    return true;
  }

  bool containTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  void changeTodos(List<dynamic> select) {
    debugPrint('select: $select');
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTodo(String title) {
    var todo = {
      'title': title,
      'done': false,
    };
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var doneTodo = {
      'title': title,
      'done': true,
    };
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);

    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIndex = tasks.indexOf(task.value!);
    tasks[oldIndex] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {
      'title': title,
      'done': false,
    };
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {
      'title': title,
      'done': true,
    };
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void undoDoneTodo(String title) {
    var doneTodo = {
      'title': title,
      'done': true,
    };
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    var doingTodo = {
      'title': title,
      'done': false,
    };
    doingTodos.add(doingTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    debugPrint('doneTodo: $doneTodo');
    int index = doneTodos.indexOf(doneTodo);
    debugPrint('index: $index');
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res++;
      }
    }
    return res;
  }

  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += getDoneTodo(tasks[i]);
      }
    }
    return res;
  }
}
