import 'package:flutter/material.dart';
import 'package:ffproject/model/task_model.dart';
import 'package:ffproject/service/task_service.dart';
import 'package:ffproject/screens/create_task_screen.dart';
import 'package:ffproject/screens/alerts_screen.dart';
import 'package:ffproject/widgets/task_card.dart';
import 'package:ffproject/widgets/smart_summary.dart';
import 'package:ffproject/widgets/category_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedCategory = "All";

  final List<String> categories = [
    "All",
    "Study",
    "Personal",
    "Important",
    "Meeting",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 227, 255),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildDateSelector(),
            const SizedBox(height: 12),
            _buildSmartSummary(),
            const SizedBox(height: 12),
            CategoryFilter(
              categories: categories,
              selected: selectedCategory,
              onSelected: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF7F5AF0),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
          );
          setState(() {});
        },
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    Text("Home", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications),
                    Text("Alerts", style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          final isSelected =
              date.day == selectedDate.day &&
              date.month == selectedDate.month &&
              date.year == selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7F5AF0) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${date.day}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    _dayName(date.weekday),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmartSummary() {
    return FutureBuilder<List<TaskModel>>(
      future: TaskService.getTasksByDate(selectedDate),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final tasks = snapshot.data!;

        final completed = tasks.where((t) => t.isCompleted == true).length;

        final remaining = tasks.where((t) => t.isCompleted != true).length;

        final now = DateTime.now();

        final overdue = tasks.where((t) {
          if (t.taskDatetime == null) return false;
          final taskTime = DateTime.parse(t.taskDatetime!);
          return taskTime.isBefore(now) && t.isCompleted != true;
        }).length;

        return SmartSummaryCard(
          completed: completed,
          remaining: remaining,
          overdue: overdue,
        );
      },
    );
  }

  Widget _buildTaskList() {
    return FutureBuilder<List<TaskModel>>(
      future: TaskService.getTasksByDate(selectedDate),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var tasks = snapshot.data!;

        if (selectedCategory != "All") {
          tasks = tasks.where((t) => t.category == selectedCategory).toList();
        }

        if (tasks.isEmpty) {
          return const Center(child: Text("No tasks"));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];

            return TaskCard(
              task: task,

              onToggleComplete: () async {
                await TaskService.updateTask(task.id!, {
                  'is_completed': !(task.isCompleted ?? false),
                });
                setState(() {});
              },

              onDelete: () async {
                await TaskService.deleteTask(task.id!);
                setState(() {});
              },
            );
          },
        );
      },
    );
  }

  String _dayName(int day) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[day - 1];
  }
}
