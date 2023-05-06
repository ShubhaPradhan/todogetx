import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '/app/core/utils/extensions.dart';
import '/app/core/values/colors.dart';
import '/app/modules/home/controller.dart';
import '/app/widgets/icons.dart';

import '../../../data/models/task.dart';

class AddCart extends StatelessWidget {
  final homeController = Get.find<HomeController>();
  AddCart({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(
              vertical: 5.0.wp,
            ),
            radius: 5,
            title: 'Task Type',
            content: Form(
              key: homeController.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeController.editController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                    child: Wrap(
                      spacing: 2.0.wp,
                      children: icons
                          .map(
                            (e) => Obx(() {
                              final index = icons.indexOf(e);
                              return ChoiceChip(
                                selectedColor: Colors.grey[200],
                                pressElevation: 0,
                                backgroundColor: Colors.white,
                                label: e,
                                selected:
                                    homeController.chipIndex.value == index,
                                onSelected: (_) {
                                  debugPrint(homeController.chipIndex.value
                                      .toString());
                                  homeController.chipIndex.value = index;
                                  debugPrint(homeController.chipIndex.value
                                      .toString());
                                },
                              );
                            }),
                          )
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      maximumSize: const Size(150, 40),
                    ),
                    onPressed: () {
                      if (homeController.formKey.currentState!.validate()) {
                        debugPrint(icons[homeController.chipIndex.value]
                            .icon!
                            .codePoint
                            .toString());
                        debugPrint(icons[homeController.chipIndex.value]
                            .color!
                            .toHex()
                            .toString());
                        int icon = icons[homeController.chipIndex.value]
                            .icon!
                            .codePoint;
                        String color = icons[homeController.chipIndex.value]
                            .color!
                            .toHex();

                        var task = Task(
                          title: homeController.editController.text,
                          icon: icon,
                          color: color,
                        );

                        Get.back();
                        homeController.addTask(task)
                            ? EasyLoading.showSuccess('Task added successfully')
                            : EasyLoading.showError('Task already exists');
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          );
          homeController.editController.clear();
          homeController.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
