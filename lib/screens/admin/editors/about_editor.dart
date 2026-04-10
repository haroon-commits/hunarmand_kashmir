import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dynamic_content_provider.dart';
import '../../../models/content_model.dart';
import '../../../theme/app_theme.dart';

class AboutEditor extends StatefulWidget {
  const AboutEditor({super.key});

  @override
  State<AboutEditor> createState() => _AboutEditorState();
}

class _AboutEditorState extends State<AboutEditor> {
  final _headlineController = TextEditingController();
  final _storyController = TextEditingController();
  final _missionController = TextEditingController();
  final _visionController = TextEditingController();
  final _valuesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final content = context.read<DynamicContentProvider>().content;
    _headlineController.text = content.aboutStoryHeadline;
    _storyController.text = content.aboutStoryText;
    _missionController.text = content.aboutMissionText;
    _visionController.text = content.aboutVisionText;
    _valuesController.text = content.aboutValuesText;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Screen Editor',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          _buildSection('Story Section', [
            _buildTextField('Story Headline', _headlineController),
            const SizedBox(height: 16),
            _buildTextField('Story Text', _storyController, maxLines: 6),
          ]),
          const SizedBox(height: 24),
          _buildSection('Mission & Vision', [
            _buildTextField('Mission Text', _missionController, maxLines: 4),
            const SizedBox(height: 16),
            _buildTextField('Vision Text', _visionController, maxLines: 4),
          ]),
          const SizedBox(height: 24),
          _buildSection('Values', [
            _buildTextField('Values Text', _valuesController, maxLines: 4),
          ]),
          const SizedBox(height: 24),
          _buildSection('Our Team', [
            _buildTeamOrganizer(context),
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.read<DynamicContentProvider>().updateAbout(
                    _headlineController.text,
                    _storyController.text,
                    _missionController.text,
                    _visionController.text,
                    _valuesController.text,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('About screen updated!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            ),
            child: const Text('Save About Changes'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamOrganizer(BuildContext context) {
    final provider = context.watch<DynamicContentProvider>();
    final team = provider.content.teamMembers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Team Members',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showTeamDialog(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Member'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (team.isEmpty)
          const Text('No team members added yet.')
        else
          ...team.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.lightTeal,
                  child: member.imageUrl.startsWith('http')
                      ? null
                      : Text(member.imageUrl, style: const TextStyle(fontSize: 18)),
                ),
                title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(member.role),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showTeamDialog(context, member: member, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () {
                        final updated = List<TeamMember>.from(team)..removeAt(index);
                        provider.updateTeamMembers(updated);
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  void _showTeamDialog(BuildContext context, {TeamMember? member, int? index}) {
    final nameController = TextEditingController(text: member?.name ?? '');
    final roleController = TextEditingController(text: member?.role ?? '');
    final imageController = TextEditingController(text: member?.imageUrl ?? '👤');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(member == null ? 'Add Team Member' : 'Edit Team Member'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL or Emoji'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final provider = context.read<DynamicContentProvider>();
              final newMember = TeamMember(
                imageUrl: imageController.text,
                name: nameController.text,
                role: roleController.text,
              );
              final updated = List<TeamMember>.from(provider.content.teamMembers);
              if (index == null) {
                updated.add(newMember);
              } else {
                updated[index] = newMember;
              }
              provider.updateTeamMembers(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreen,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
