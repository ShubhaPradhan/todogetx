import '../../../data/providers/task/provider.dart';
import '../../models/task.dart';

class TaskRepository {
  TaskProvider taskProvider;

  TaskRepository({
    required this.taskProvider,
  });

  List<Task> readTask() => taskProvider.readTask();
  void writeTask(List<Task> tasks) => taskProvider.writeTask(tasks);
}
