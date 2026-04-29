/// ═══════════════════════════════════════════════════════════════════════
/// FILE: courses_editor.dart
/// PURPOSE: Admin interface for complete CRUD operations on the curriculum
///          catalog, managing training programs and their constituent topics.
/// CONNECTIONS:
///   - USED BY: admin_dashboard_screen.dart
///   - MUTATES: AppContent via dynamic_content_provider.dart
/// ═══════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/dynamic_content_provider.dart';
import '../../models/content_model.dart';
import '../../widgets/utils/dynamic_icon.dart';

// ─── COURSESEDITORUICONFIG ──────────────────────────────
/// Isolated UI configuration specific to courses_editor.dart.
class CoursesEditorUIConfig {
  // Brand Colors used locally
  static const Color darkGreen = Color(0xFF0D3320);
  static const Color lightTeal = Color(0xFFE8F5F3);
  static const Color textDark = Color(0xFF1A1A1A);
}

class CoursesEditor extends StatelessWidget {
  const CoursesEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DynamicContentProvider>();
    final courses = provider.content.courses;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Courses Management',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: CoursesEditorUIConfig.textDark,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCourseDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add New Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoursesEditorUIConfig.darkGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── PAGE SECTION EDITOR ──────────────────────────────────────────
          ExpansionTile(
            title: const Text('Edit Page Sections',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle:
                const Text('Learning Choice, Locations, and Orphan Support'),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSectionHeader('Learning Choice Section'),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Section Title'),
                      controller: TextEditingController(
                          text: provider.content.courseLearningChoiceTitle),
                      onSubmitted: (val) => provider.updateContent(provider
                          .content
                          .copyWith(courseLearningChoiceTitle: val)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                          labelText: 'Section Description'),
                      controller: TextEditingController(
                          text:
                              provider.content.courseLearningChoiceDescription),
                      onSubmitted: (val) => provider.updateContent(provider
                          .content
                          .copyWith(courseLearningChoiceDescription: val)),
                    ),
                    const Divider(height: 32),
                    _buildSectionHeader('Location 1 (Freelancing Hub)'),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'Icon'),
                            controller: TextEditingController(
                                text: provider.content.courseLocation1Icon),
                            onSubmitted: (val) => provider.updateContent(
                                provider.content
                                    .copyWith(courseLocation1Icon: val)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            controller: TextEditingController(
                                text: provider.content.courseLocation1Title),
                            onSubmitted: (val) => provider.updateContent(
                                provider.content
                                    .copyWith(courseLocation1Title: val)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Address/Text'),
                      controller: TextEditingController(
                          text: provider.content.courseLocation1Text),
                      onSubmitted: (val) => provider.updateContent(
                          provider.content.copyWith(courseLocation1Text: val)),
                    ),
                    const Divider(height: 32),
                    _buildSectionHeader('Orphan Support Card'),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'Icon'),
                            controller: TextEditingController(
                                text: provider.content.courseOrphanSupportIcon),
                            onSubmitted: (val) => provider.updateContent(
                                provider.content
                                    .copyWith(courseOrphanSupportIcon: val)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                            controller: TextEditingController(
                                text:
                                    provider.content.courseOrphanSupportTitle),
                            onSubmitted: (val) => provider.updateContent(
                                provider.content
                                    .copyWith(courseOrphanSupportTitle: val)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                      controller: TextEditingController(
                          text:
                              provider.content.courseOrphanSupportDescription),
                      onSubmitted: (val) => provider.updateContent(provider
                          .content
                          .copyWith(courseOrphanSupportDescription: val)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Text('Individual Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: CoursesEditorUIConfig.lightTeal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: renderDynamicIcon(course.icon,
                          color: CoursesEditorUIConfig.darkGreen, size: 20),
                    ),
                  ),
                  title: Text(course.title,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  subtitle: Text(course.fee),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showCourseDialog(context,
                            course: course, index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await provider.removeCourse(index);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('❌ Delete failed: $e'),
                                  backgroundColor: Colors.red.shade700,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
              width: 4, height: 16, color: CoursesEditorUIConfig.darkGreen),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  void _showCourseDialog(BuildContext context, {Course? course, int? index}) {
    final titleController = TextEditingController(text: course?.title);
    final descController = TextEditingController(text: course?.description);
    final feeController = TextEditingController(text: course?.fee);
    final durationController = TextEditingController(text: course?.duration);
    final iconController = TextEditingController(text: course?.icon ?? '🎓');
    final linkController =
        TextEditingController(text: course?.registrationLink ?? '');

    // List of controllers for individual topics
    final List<TextEditingController> topicControllers = (course?.topics ?? [])
        .map((t) => TextEditingController(text: t))
        .toList();

    if (topicControllers.isEmpty) {
      topicControllers.add(TextEditingController());
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(course == null ? 'Add Course' : 'Edit Course'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: iconController,
                      decoration: const InputDecoration(
                          labelText: 'Icon (Emoji or URL)')),
                  TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title')),
                  TextField(
                      controller: descController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 2),
                  TextField(
                      controller: feeController,
                      decoration: const InputDecoration(labelText: 'Fee')),
                  TextField(
                      controller: durationController,
                      decoration: const InputDecoration(labelText: 'Duration')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        labelText: 'Registration Link (URL)',
                        hintText: 'https://forms.google.com/...',
                        prefixIcon: Icon(Icons.link),
                      )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Curriculum Topics',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            topicControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Topic'),
                      ),
                    ],
                  ),
                  const Divider(),
                  ...topicControllers.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: entry.value,
                              decoration: InputDecoration(
                                hintText: 'Topic ${entry.key + 1}',
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                color: Colors.red, size: 20),
                            onPressed: () {
                              setDialogState(() {
                                topicControllers.removeAt(entry.key);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final newCourse = Course(
                  title: titleController.text,
                  description: descController.text,
                  fee: feeController.text,
                  duration: durationController.text,
                  icon: iconController.text,
                  registrationLink: linkController.text.trim().isEmpty
                      ? null
                      : linkController.text.trim(),
                  topics: topicControllers
                      .map((c) => c.text)
                      .where((t) => t.isNotEmpty)
                      .toList(),
                );
                final provider = context.read<DynamicContentProvider>();
                try {
                  if (index == null) {
                    await provider.addCourse(newCourse);
                  } else {
                    await provider.updateCourse(index, newCourse);
                  }
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Save failed: $e'),
                        backgroundColor: Colors.red.shade700,
                        duration: const Duration(seconds: 6),
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
