import 'package:ffproject/model/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  static final supabase = Supabase.instance.client;

  // ================= CREATE =================

  static Future<void> createTask({
    required String title,
    required String description,
    required String category,
    required DateTime dateTime,
  }) async {
    await supabase.from('tasks').insert({
      'title': title,
      'description': description,
      'category': category,
      'task_datetime': dateTime.toIso8601String(),
      'is_completed': false,
    });
  }

  // ================= READ ALL =================

  static Future<List<TaskModel>> getTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return response.map<TaskModel>((e) => TaskModel.fromJson(e)).toList();
  }

  // ================= READ BY DATE =================

  static Future<List<TaskModel>> getTasksByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);

    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final response = await supabase
        .from('tasks')
        .select()
        .gte('task_datetime', startOfDay.toIso8601String())
        .lte('task_datetime', endOfDay.toIso8601String());

    return response.map<TaskModel>((e) => TaskModel.fromJson(e)).toList();
  }

  // ================= UPDATE =================

  static Future<void> updateTask(String id, Map<String, dynamic> data) async {
    await supabase.from('tasks').update(data).eq('id', id);
  }

  // ================= DELETE =================

  static Future<void> deleteTask(String id) async {
    await supabase.from('tasks').delete().eq('id', id);
  }
}
