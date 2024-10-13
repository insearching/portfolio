import 'package:flutter/material.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/ui/resume_tabs.dart';

class Resume extends StatefulWidget {
  const Resume({
    required this.educations,
    required this.skills,
    super.key,
  });

  final List<Education> educations;
  final List<Skill> skills;

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          const ContainerTitle(title: 'My Resume', subtitle: '10+ years of experience'),
          const SizedBox(height: 24.0),
          ResumeTabs(
            educations: widget.educations,
            skills: widget.skills,
          )
        ],
      ),
    );
  }
}
