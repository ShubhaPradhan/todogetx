import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/app/core/utils/extensions.dart';

import '../home/controller.dart';

class DetailPage extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var task = homeController.task.value!;
    var color = HexColor.fromHex(task.color);

    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(3.0.wp),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                  homeController.changeTask(null);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0.wp,
          ),
          child: Row(
            children: [
              Icon(
                IconData(
                  task.icon,
                  fontFamily: 'MaterialIcons',
                ),
                color: color,
              ),
              SizedBox(
                width: 3.0.wp,
              ),
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
