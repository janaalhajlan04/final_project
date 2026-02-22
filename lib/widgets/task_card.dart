import 'package:flutter/material.dart';
import 'package:ffproject/model/task_model.dart';
import 'package:ffproject/screens/create_task_screen.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onDelete,
  });

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return "${date.day}/${date.month}/${date.year} • $hour:$minute";
  }

  IconData _getCategoryIcon(String? category) {
    final cat = category?.toLowerCase();

    switch (cat) {
      case "study":
        return Icons.menu_book_rounded;
      case "personal":
        return Icons.person_rounded;
      case "important":
        return Icons.priority_high_rounded;
      case "meeting":
        return Icons.groups_rounded;
      default:
        return Icons.task_rounded;
    }
  }

  Color _getAccentColor(String? category) {
    final cat = category?.toLowerCase();

    switch (cat) {
      case "study":
        return const Color(0xFF6A5AE0);
      case "personal":
        return const Color(0xFF9C6CFF);
      case "important":
        return const Color(0xFF5E50E6);
      case "meeting":
        return const Color(0xFF7B6EF6);
      default:
        return const Color(0xFF6A5AE0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(task.category);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CreateTaskScreen(task: task)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Accent Line
            Container(
              width: 5,
              height: 55,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 14),

            // Icon
            CircleAvatar(
              radius: 20,
              backgroundColor: accentColor.withOpacity(0.15),
              child: Icon(_getCategoryIcon(task.category), color: accentColor),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

            // Complete Button
            IconButton(
              icon: Icon(
                task.isCompleted == true
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted == true ? Colors.green : Colors.grey,
              ),
              onPressed: onToggleComplete,
            ),

            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),

              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateTaskScreen(task: task),
                    ),
                  );
                }

                if (value == 'delete') {
                  onDelete?.call();
                }
              },

              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18),
                      SizedBox(width: 8),
                      Text("Edit"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text("Delete", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
