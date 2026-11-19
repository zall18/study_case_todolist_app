/// Model sederhana untuk satu item tugas atau catatan harian.
class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  final String id;
  final String title;
  final bool isDone;

  /// Mengembalikan salinan tugas dengan properti yang diperbarui.
  TaskItem copyWith({
    String? id,
    String? title,
    bool? isDone,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}
