import 'package:get/get.dart';
import '/app/data/providers/task/provider.dart';
import '/app/data/services/storage/repository.dart';
import '/app/modules/home/controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}
