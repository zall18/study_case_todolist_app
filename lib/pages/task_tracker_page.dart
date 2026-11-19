import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../widgets/task_tile.dart';

/// Halaman utama Mini Task Tracker berbasis state lokal (setState).
class TaskTrackerPage extends StatefulWidget {
  const TaskTrackerPage({super.key});

  @override
  State<TaskTrackerPage> createState() => _TaskTrackerPageState();
}

class _TaskTrackerPageState extends State<TaskTrackerPage> {
  final List<TaskItem> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  int _nextId = 0;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _taskController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Judul catatan tidak boleh kosong.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    setState(() {
      _nextId += 1;
      _tasks.add(
        TaskItem(
          id: 'task_$_nextId',
          title: title,
        ),
      );
      _taskController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void _toggleTask(String id) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index == -1) return;
      _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _tasks.where((task) => task.isDone).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE4E4E7)),
        ),
        title: const Text(
          'Catatan Harian',
          style: TextStyle(
            color: Color(0xFF18181B),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          if (_tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE4E4E7)),
                  ),
                  child: Text(
                    '$completedCount/${_tasks.length} selesai',
                    style: const TextStyle(
                      color: Color(0xFF18181B),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addTask(),
                        style: const TextStyle(
                          color: Color(0xFF18181B),
                          fontSize: 14.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tulis catatan atau tugas baru...',
                          hintStyle: TextStyle(color: Color(0xFFA1A1AA)),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _addTask,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF18181B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _tasks.isEmpty
                    ? const _EmptyTaskState()
                    : ListView.separated(
                        itemCount: _tasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return TaskTile(
                            key: ValueKey(task.id),
                            task: task,
                            onToggle: () => _toggleTask(task.id),
                            onDelete: () => _deleteTask(task.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTaskState extends StatelessWidget {
  const _EmptyTaskState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE4E4E7)),
              ),
              child: const Icon(
                Icons.note_alt_outlined,
                size: 24,
                color: Color(0xFF71717A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Belum ada catatan',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF18181B),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tambahkan catatan atau tugas pertamamu di atas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF71717A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
