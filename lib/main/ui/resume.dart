import 'package:flutter/material.dart';
import 'package:portfolio/main/data/device_info.dart';
import 'package:portfolio/main/data/device_type.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/ui/components/container_title.dart';
import 'package:portfolio/main/ui/resume_tabs.dart';
import 'package:provider/provider.dart';

class Resume extends StatefulWidget {
  const Resume({
    required this.educations,
    required this.skills,
    required this.posts,
    super.key,
  });

  final List<Education> educations;
  final List<Skill> skills;
  final List<Post> posts;

  @override
  State<Resume> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  Widget build(BuildContext context) {
    final isPhone = context.read<DeviceInfo>().deviceType == DeviceType.phone;

    return Padding(
      padding: EdgeInsets.only(top: isPhone ? 16.0 : 64.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'My Resume',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 24.0),
          ResumeTabs(
            educations: widget.educations,
            skills: widget.skills,
            posts: widget.posts
          )
        ],
      ),
    );
  }
}
