import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/app/core/utils/extensions.dart';

import '../../home/controller.dart';

class DoingList extends StatelessWidget {
  final homeControler = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeControler.doingTodos.isEmpty && homeControler.doneTodos.isEmpty
          ? Column(
              children: [
                Image.asset(
                  'assets/images/no-task.png',
                  fit: BoxFit.cover,
                  width: 80.0.wp,
                ),
                Text(
                  'Add Task',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0.sp,
                  ),
                )
              ],
            )
          : ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...homeControler.doingTodos
                    .map(
                      (element) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9.0.wp,
                          vertical: 3.0.wp,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.grey),
                                value: element['done'],
                                onChanged: (value) {
                                  homeControler.doneTodo(element['title']);
                                  // show undo snackbar
                                  Get.snackbar(
                                    'Done',
                                    'Task marked as done',
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                    mainButton: TextButton(
                                      onPressed: () {
                                        homeControler
                                            .undoDoneTodo(element['title']);
                                      },
                                      child: const Text('Undo'),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 3.0.wp,
                            ),
                            Text(
                              element['title'],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                if (homeControler.doingTodos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                    child: const Divider(
                      thickness: 2,
                    ),
                  ),
              ],
            ),
    );
  }
}
