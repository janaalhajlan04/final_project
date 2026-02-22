import 'package:ffproject/widgets/gradient_header.dart';
import 'package:flutter/material.dart';
import 'package:ffproject/model/task_model.dart';
import 'package:ffproject/service/task_service.dart';

class CreateTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const CreateTaskScreen({super.key, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  String selectedCategory = "Meeting";

  bool isEdit = false;

  final List<String> categories = ["Meeting", "Personal", "Important", "Study"];

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      isEdit = true;

      titleController.text = widget.task!.title ?? "";

      descriptionController.text = widget.task!.description ?? "";

      selectedCategory = widget.task!.category ?? "Meeting";

      if (widget.task!.taskDatetime != null) {
        final date = DateTime.parse(widget.task!.taskDatetime!);

        selectedDate = date;
        selectedTime = TimeOfDay(hour: date.hour, minute: date.minute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 227, 255),
      body: Column(
        children: [
          GradientHeader(title: isEdit ? "Edit Task" : "Create Task"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: titleController,
                      label: "Title",
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: descriptionController,
                      label: "Description",
                    ),

                    const SizedBox(height: 16),

                    _buildCategoryDropdown(),

                    const SizedBox(height: 16),

                    _buildDatePicker(),

                    const SizedBox(height: 16),

                    _buildTimePicker(),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _saveTask,
                        child: Container(
                          height:55,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          child: Text(
                            isEdit ? "Update" : "Create",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SAVE =================

  Future<void> _saveTask() async {
    final DateTime fullDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (isEdit) {
      await TaskService.updateTask(widget.task!.id!, {
        "title": titleController.text,
        "description": descriptionController.text,
        "category": selectedCategory,
        "task_datetime": fullDateTime.toIso8601String(),
      });
    } else {
      await TaskService.createTask(
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory,
        dateTime: fullDateTime,
      );
    }

    Navigator.pop(context);
  }

  // ================= UI =================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: categories
          .map(
            (category) =>
                DropdownMenuItem(value: category, child: Text(category)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value!;
        });
      },
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Select Date"),
      subtitle: Text(
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Select Time"),
      subtitle: Text(
        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
      ),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );

        if (picked != null) {
          setState(() {
            selectedTime = picked;
          });
        }
      },
    );
  }
}
