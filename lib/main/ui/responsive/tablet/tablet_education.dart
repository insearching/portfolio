import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/ui/components/education_container.dart';

class TabletEducationWidget extends StatelessWidget {
  const TabletEducationWidget({
    required this.educations,
    Key? key,
  }) : super(key: key);

  final List<Education> educations;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: educations.length,
      itemBuilder: (context, index) => EducationContainer(
        education: educations[index],
      ),
    );
  }
}
