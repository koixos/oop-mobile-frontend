class TaskItem {
  final String title;
  final String mission;
  final String context;
  final DateTime dueDate;
  final bool urgent;
  final bool important;
  final bool done;

  const TaskItem({
    required this.title,
    required this.mission,
    required this.context,
    required this.dueDate,
    required this.urgent,
    required this.important,
    this.done = false,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final dueDateRaw = json["dueDate"];
    return TaskItem(
      title: json["title"] as String? ?? "",
      mission: json["mission"] as String? ?? "",
      context: json["context"] as String? ?? "",
      dueDate:
          DateTime.tryParse(dueDateRaw as String? ?? "") ?? DateTime.now(),
      urgent: json["urgent"] as bool? ?? false,
      important: json["important"] as bool? ?? false,
      done: json["done"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "mission": mission,
      "context": context,
      "dueDate": dueDate.toIso8601String(),
      "urgent": urgent,
      "important": important,
      "done": done,
    };
  }
}
