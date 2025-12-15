import 'package:flutter/material.dart';
import 'package:portfolio/main/ui/admin/widgets/blog_form.dart';
import 'package:portfolio/main/ui/admin/widgets/education_form.dart';
import 'package:portfolio/main/ui/admin/widgets/position_form.dart';
import 'package:portfolio/main/ui/admin/widgets/project_form.dart';
import 'package:portfolio/main/ui/menu/navigation_menu.dart';

/// Main admin content with tabs for different sections
class AdminContent extends StatefulWidget {
  const AdminContent({super.key});

  @override
  State<AdminContent> createState() => _AdminContentState();
}

class _AdminContentState extends State<AdminContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Only create tabs for menu items that have forms (excluding Home, Features, and Contact)
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(
                icon: Icon(Icons.article),
                text: 'Blog Posts',
              ),
              Tab(
                icon: Icon(Icons.work),
                text: 'Projects',
              ),
              Tab(
                icon: Icon(Icons.school),
                text: 'Education',
              ),
              Tab(
                icon: Icon(Icons.business),
                text: 'Positions',
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              BlogForm(),
              ProjectForm(),
              EducationForm(),
              PositionForm(),
            ],
          ),
        ),
      ],
    );
  }
}
