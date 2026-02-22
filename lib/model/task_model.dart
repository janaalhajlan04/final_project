class TaskModel {
  String? id;
  String? title;
  String? description;
  String? taskDatetime;
  String? createdAt;
  String? category;
  double? progress;
  bool? isCompleted;

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.taskDatetime,
    this.createdAt,
    this.category,
    this.progress,
    this.isCompleted,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    taskDatetime = json['task_datetime'];
    createdAt = json['created_at'];
    category = json['category'];
    progress = (json['progress'] ?? 0).toDouble();
    isCompleted = json['is_completed'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['description'] = description;
    data['task_datetime'] = taskDatetime;
    data['category'] = category;
    data['progress'] = progress;
    data['is_completed'] = isCompleted;
    return data;
  }
}
