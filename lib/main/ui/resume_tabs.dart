import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/components/ripple_button.dart';
import 'package:portfolio/main/ui/components/skill_progress_bar.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/utils/measure_size.dart';

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

  double? mTabWidth;

  @override
  Widget build(BuildContext context) {
    return MeasureSize(
      onChange: (Size size) {
        setState(() {
          mTabWidth = size.width / 3;
        });
      },
      child: DefaultTabController(
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
                  tabs: [
                    SizedBox(width: mTabWidth, child: const RippleButton(text: 'Education')),
                    SizedBox(width: mTabWidth, child: const RippleButton(text: 'Professional Skills')),
                    SizedBox(width: mTabWidth, child: const RippleButton(text: 'Experience')),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const Center(child: Text('Tab 1 Content')),
                    GridView.count(
                      childAspectRatio: 4.0,
                      shrinkWrap: true,
                      primary: false,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: widget.skills
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
                    const Center(child: Text('Tab 3 Content')),
                  ],
                ),
              ),
            ],
          ),
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
