import 'package:ffproject/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:ffproject/model/task_model.dart';
import 'package:ffproject/service/task_service.dart';
import 'package:ffproject/screens/create_task_screen.dart';

class TaskDetailsScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TaskModel task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    DateTime? taskTime;

    if (task.taskDatetime != null) {
      taskTime = DateTime.parse(task.taskDatetime!);
    }

    bool isOverdue = false;
    if (taskTime != null &&
        taskTime.isBefore(now) &&
        task.isCompleted != true) {
      isOverdue = true;
    }

    String status;
    Color statusColor;

    if (task.isCompleted == true) {
      status = "Completed";
      statusColor = Colors.green;
    } else if (isOverdue) {
      status = "Overdue";
      statusColor = Colors.red;
    } else {
      status = "Pending";
      statusColor = Colors.orange;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 227, 255),
      body: Column(
        children: [
          const GradientHeader(title: "Task Details"),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title ?? "",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          task.description ?? "No description",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow("Category", task.category ?? "Not specified"),
                        const SizedBox(height: 8),
                        _buildRow(
                          "Date",
                          taskTime != null
                              ? "${taskTime.day}/${taskTime.month}/${taskTime.year}"
                              : "-",
                        ),
                        const SizedBox(height: 8),
                        _buildRow(
                          "Time",
                          taskTime != null
                              ? "${taskTime.hour.toString().padLeft(2, '0')}:${taskTime.minute.toString().padLeft(2, '0')}"
                              : "-",
                        ),
                        const SizedBox(height: 8),
                        _buildRow("Status", status, valueColor: statusColor),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task.isCompleted == true
                            ? Colors.grey
                            : Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        await TaskService.updateTask(task.id!, {
                          'is_completed': !(task.isCompleted ?? false),
                        });

                        setState(() {
                          task.isCompleted = !(task.isCompleted ?? false);
                        });
                      },
                      child: Text(
                        task.isCompleted == true
                            ? "Mark as Incomplete"
                            : "Mark as Completed",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F5AF0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateTaskScreen(task: task),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Edit Task"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Task"),
                            content: const Text(
                              "Are you sure you want to delete this task?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await TaskService.deleteTask(task.id!);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Delete Task"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: valueColor ?? Colors.black)),
      ],
    );
  }
}
