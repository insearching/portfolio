import 'package:flutter/material.dart';
import 'package:portfolio/main/data/device_info.dart';
import 'package:portfolio/main/data/device_type.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/skill.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_blog.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_education.dart';
import 'package:portfolio/main/ui/responsive/mobile/mobile_professional_skills.dart';
import 'package:portfolio/utils/colors.dart';
import 'package:provider/provider.dart';

class MobileResume extends StatefulWidget {
  const MobileResume({
    required this.educations,
    required this.skills,
    required this.posts,
    super.key,
  });

  final List<Education> educations;
  final List<Skill> skills;
  final List<Post> posts;

  @override
  State<MobileResume> createState() => _MobileResumeState();
}

class _MobileResumeState extends State<MobileResume> {
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
          _ResumeTabs(
            educations: widget.educations,
            skills: widget.skills,
            posts: widget.posts,
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
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Education> educations;
  final List<Skill> skills;
  final List<Post> posts;

  @override
  _ResumeTabsState createState() => _ResumeTabsState();
}

class _ResumeTabsState extends State<_ResumeTabs>
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
                  padding: const EdgeInsets.only(top: 16.0),
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
                  MobileEducationWidget(educations: widget.educations),
                  MobileProfessionalSkillsWidget(skills: widget.skills),
                  MobileBlogWidget(posts: widget.posts)
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
