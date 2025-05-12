import 'package:flutter/material.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/resume/education.dart';
import 'package:portfolio/main/ui/resume/professional_skills.dart';
import 'package:portfolio/utils/colors.dart';

import 'responsive/desktop/desktop_blog.dart';

class ResumeTabs extends StatefulWidget {
  const ResumeTabs({
    required this.educations,
    required this.skills,
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Education> educations;
  final List<Skill> skills;
  final List<Post> posts;

  @override
  ResumeTabsState createState() => ResumeTabsState();
}

class ResumeTabsState extends State<ResumeTabs>
    with SingleTickerProviderStateMixin {
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
        height: 900,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: ElevatedContainer(
                child: TabBar(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
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
                  tabs: const [
                    Tab(text: 'Education'),
                    Tab(text: 'Professional Skills'),
                    Tab(text: 'Blog'),
                  ],
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
                  DesktopBlogWidget(posts: widget.posts)
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
