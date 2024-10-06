import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/components/skill_progress_bar.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/utils/colors.dart';

class ResumeTabs extends StatefulWidget {
  const ResumeTabs({
    required this.skills,
    Key? key,
  }) : super(key: key);

  final List<Skill> skills;

  @override
  ResumeTabsState createState() => ResumeTabsState();
}

class ResumeTabsState extends State<ResumeTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  double? mTabWidth;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: 500,
        child: Column(
          children: <Widget>[
            ElevatedContainer(
              child: TabBar(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                indicatorColor: Colors.transparent,
                // indicator: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5.0),
                //   gradient: const LinearGradient(
                //     colors: [
                //       UIColors.backgroundColorDark,
                //       UIColors.backgroundColorDark,
                //       UIColors.backgroundColorDark,
                //       UIColors.backgroundColorDark,
                //       UIColors.backgroundColorLight,
                //     ],
                //     begin: Alignment.bottomRight,
                //     end: Alignment.topLeft,
                //   ),
                //   boxShadow: const [
                //     BoxShadow(
                //       color: Color(0xFF313135),
                //       offset: Offset(-4, -4),
                //       blurRadius: 10,
                //     ),
                //     BoxShadow(
                //       color: Color(0xDE161515),
                //       offset: Offset(4, 4),
                //       blurRadius: 10,
                //     ),
                //   ],
                // ),
                controller: _tabController,
                labelColor: UIColors.accent,
                unselectedLabelColor: Colors.grey,
                indicatorWeight: 4,
                dividerHeight: 0,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Education'),
                  Tab(text: 'Professional Skills'),
                  Tab(text: 'Experience'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text('Coming soon')),
                  _ProfessionalSkills(skills: widget.skills),
                  // GridView.count(
                  //   childAspectRatio: 4.0,
                  //   shrinkWrap: true,
                  //   primary: false,
                  //   crossAxisSpacing: 10,
                  //   mainAxisSpacing: 10,
                  //   crossAxisCount: 3,
                  //   children: widget.skills
                  //       .map(
                  //         (skill) => SkillProgressBar(
                  //           title: skill.title,
                  //           progress: skill.value,
                  //           startColor: Colors.purpleAccent,
                  //           endColor: Colors.red,
                  //         ),
                  //       )
                  //       .toList(),
                  // ),
                  const Center(child: Text('Coming soon')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _ProfessionalSkills extends StatefulWidget {
  const _ProfessionalSkills({
    required this.skills,
    Key? key,
  }) : super(key: key);

  final List<Skill> skills;

  @override
  State<_ProfessionalSkills> createState() => _ProfessionalSkillsState();
}

class _ProfessionalSkillsState extends State<_ProfessionalSkills> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
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
