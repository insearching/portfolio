import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/model/device_type.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/domain/model/skill.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/resume/education_widget.dart';
import 'package:portfolio/main/ui/resume/professional_skills.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:provider/provider.dart';

class ResumeWidget extends StatelessWidget {
  const ResumeWidget({
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
    final deviceType = context.read<DeviceInfo>().deviceType;

    return Padding(
      padding: EdgeInsets.only(
        top: deviceType.isDesktop ? 64.0 : 16.0,
        bottom: 64.0,
      ),
      child: Column(
        children: [
          Text(
            'My Resume',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 24.0),
          if (tabs.isNotEmpty)
            _ResumeTabs(
              educations: educations,
              skills: skills,
              tabs: tabs,
              isPhone: deviceType.isPhone,
              isDesktop: deviceType.isDesktop,
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
    required this.isPhone,
    required this.isDesktop,
  });

  final List<Education> educations;
  final List<Skill> skills;
  final List<String> tabs;
  final bool isPhone;
  final bool isDesktop;

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
    if (widget.isDesktop) {
      _tabController.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDesktop) {
      return Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ElevatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: TabBar(
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
          const SizedBox(height: 16.0),
          if (_tabController.index == 0)
            EducationWidget(educations: widget.educations)
          else
            ProfessionalSkillsWidget(skills: widget.skills),
        ],
      );
    } else {
      // Mobile and Tablet
      return SizedBox(
        height: resumeTabHeight,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedContainer(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: TabBar(
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
                  EducationWidget(educations: widget.educations),
                  ProfessionalSkillsWidget(skills: widget.skills),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
