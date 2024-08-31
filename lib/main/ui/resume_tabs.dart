import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';
import 'package:portfolio/main/ui/components/skill_progress_bar.dart';
import 'package:portfolio/main/data/skill.dart';

class ResumeTabs extends StatefulWidget {
  const ResumeTabs({
    required this.skills,
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: 400,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
              child: TabBar(
                indicatorColor: Colors.transparent,
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: RippleButton(text: 'Education'),
                  ),
                  Tab(
                    child: RippleButton(text: 'Professional Skills'),
                  ),
                  Tab(
                    child: RippleButton(text: 'Experience'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const Center(child: Text('Tab 1 Content')),
                  GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: widget.skills
                          .map(
                            (skill) => SkillProgressBar(
                              title: skill.title,
                              progress: skill.value,
                              startColor: Colors.purpleAccent,
                              endColor: Colors.red,
                            ),
                          )
                          .toList()),
                  const Center(child: Text('Tab 3 Content')),
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
