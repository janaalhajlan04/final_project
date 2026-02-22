import 'package:ffproject/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:ffproject/model/task_model.dart';
import 'package:ffproject/service/task_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  Future<List<TaskModel>> _fetchTasks() async {
    return await TaskService.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 227, 255),
      body: Column(
        children: [
          const GradientHeader(title: "Alerts"),

          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: _fetchTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tasks = snapshot.data!;

                final now = DateTime.now();
                final todayDate = DateTime(now.year, now.month, now.day);

                final overdue = tasks.where((t) {
                  if (t.taskDatetime == null || t.isCompleted == true)
                    return false;

                  final parsed = DateTime.parse(t.taskDatetime!);
                  final taskDate = DateTime(
                    parsed.year,
                    parsed.month,
                    parsed.day,
                  );

                  return taskDate.isBefore(todayDate);
                }).toList();

                final today = tasks.where((t) {
                  if (t.taskDatetime == null || t.isCompleted == true)
                    return false;

                  final parsed = DateTime.parse(t.taskDatetime!);
                  final taskDate = DateTime(
                    parsed.year,
                    parsed.month,
                    parsed.day,
                  );

                  return taskDate.isAtSameMomentAs(todayDate);
                }).toList();

                final upcoming = tasks.where((t) {
                  if (t.taskDatetime == null || t.isCompleted == true)
                    return false;

                  final parsed = DateTime.parse(t.taskDatetime!);
                  final taskDate = DateTime(
                    parsed.year,
                    parsed.month,
                    parsed.day,
                  );

                  return taskDate.isAfter(todayDate);
                }).toList();

                return ListView(
                  padding: const EdgeInsets.only(bottom: 30),
                  children: [
                    if (overdue.isNotEmpty)
                      _buildSection("Overdue", overdue, Colors.red),
                    if (today.isNotEmpty)
                      _buildSection("Today", today, Colors.orange),
                    if (upcoming.isNotEmpty)
                      _buildSection("Upcoming", upcoming, Colors.green),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<TaskModel> tasks, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tasks.length.toString(),
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tasks.map((task) => _buildAlertCard(task, accentColor)).toList(),
        ],
      ),
    );
  }

  Widget _buildAlertCard(TaskModel task, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 55,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 14),
          CircleAvatar(
            radius: 20,
            backgroundColor: accentColor.withOpacity(0.15),
            child: Icon(
              Icons.notifications_rounded,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.taskDatetime != null
                      ? _formatDate(task.taskDatetime!)
                      : "",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return "${date.day}/${date.month}/${date.year} • $hour:$minute";
  }
}
