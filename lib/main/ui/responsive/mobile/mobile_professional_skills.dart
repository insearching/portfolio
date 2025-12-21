import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/ui/components/skill_progress_bar.dart';

class MobileProfessionalSkillsWidget extends StatelessWidget {
  const MobileProfessionalSkillsWidget({
    required this.skills,
    super.key,
  });

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        children: [
          ...skills.where((skill) => skill.type == SkillType.hard).map(
                (skill) => SkillProgressBar(
                  title: skill.title,
                  progress: skill.value,
                  startColor: Colors.purpleAccent,
                  endColor: Colors.red,
                ),
              ),
          ...skills.where((skill) => skill.type == SkillType.soft).map(
                (skill) => SkillProgressBar(
                  title: skill.title,
                  progress: skill.value,
                  startColor: Colors.purpleAccent,
                  endColor: Colors.red,
                ),
              ),
        ],
      ),
    );
  }
}
