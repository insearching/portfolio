import 'package:flutter/material.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_education.dart';
import 'package:portfolio/main/ui/responsive/tablet/tablet_professional_skills.dart';
import 'package:portfolio/utils/colors.dart';

class TabletResume extends StatelessWidget {
  const TabletResume({
    required this.educations,
    required this.skills,
    required this.tabs,
    super.key,
  });

  final List<Education> educations;
  final List<Skill> skills;
  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 64.0),
      child: Column(
        children: [
          Text(
            'My Resume',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 24.0),
          _ResumeTabs(
            educations: educations,
            skills: skills,
            tabs: tabs,
          )
        ],
      ),
    );
  }
}

class _ResumeTabs extends StatefulWidget {
  const _ResumeTabs({
    required this.educations,
    required this.skills,
    required this.tabs,
    Key? key,
  }) : super(key: key);

  final List<Education> educations;
  final List<Skill> skills;
  final List<String> tabs;

  @override
  _ResumeTabsState createState() => _ResumeTabsState();
}

class _ResumeTabsState extends State<_ResumeTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  double? mTabWidth;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: 900,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedContainer(
                child: TabBar(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  indicatorColor: Colors.transparent,
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _tabController,
                  labelColor: UIColors.accent,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 4,
                  dividerHeight: 0,
                  dividerColor: Colors.transparent,
                  tabs: widget.tabs.map((title) => Tab(text: title)).toList(),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  TabletEducationWidget(educations: widget.educations),
                  TabletProfessionalSkillsWidget(skills: widget.skills),
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
