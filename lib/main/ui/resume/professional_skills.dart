import 'package:flutter/material.dart';
import 'package:portfolio/main/di/service_locator.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/ui/components/skill_progress_bar.dart';

class ProfessionalSkillsWidget extends StatefulWidget {
  const ProfessionalSkillsWidget({
    required this.skills,
    super.key,
  });

  final List<Skill> skills;

  @override
  State<ProfessionalSkillsWidget> createState() => _ProfessionalSkillsState();
}

class _ProfessionalSkillsState extends State<ProfessionalSkillsWidget> {
  @override
  Widget build(BuildContext context) {
    final deviceType = locator<DeviceInfo>().deviceType;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: deviceType.isPhone
          ? Column(
              children: [
                ...widget.skills
                    .where((skill) => skill.type == SkillType.hard)
                    .map(
                      (skill) => SkillProgressBar(
                        title: skill.title,
                        progress: skill.value,
                        startColor: Colors.purpleAccent,
                        endColor: Colors.red,
                      ),
                    ),
                ...widget.skills
                    .where((skill) => skill.type == SkillType.soft)
                    .map(
                      (skill) => SkillProgressBar(
                        title: skill.title,
                        progress: skill.value,
                        startColor: Colors.purpleAccent,
                        endColor: Colors.red,
                      ),
                    ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widget.skills
                        .where((skill) => skill.type == SkillType.hard)
                        .map(
                          (skill) => SkillProgressBar(
                            title: skill.title,
                            progress: skill.value,
                            startColor: Colors.purpleAccent,
                            endColor: Colors.red,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 24.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: widget.skills
                        .where((skill) => skill.type == SkillType.soft)
                        .map(
                          (skill) => SkillProgressBar(
                            title: skill.title,
                            progress: skill.value,
                            startColor: Colors.purpleAccent,
                            endColor: Colors.red,
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
    );
  }
}
