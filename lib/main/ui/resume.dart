import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/data/repository.dart';
import 'package:portfolio/main/ui/resume_tabs.dart';

class Resume extends StatefulWidget {
  const Resume({super.key});

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 64.0, bottom: 64.0),
      child: Column(
        children: [
          ContainerTitle(title: 'My Resume', subtitle: '10+ years of experience'),
          ResumeTabs(skills: Repository.skills)
        ],
      ),
    );
  }
}
