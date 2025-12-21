import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/ui/components/education_container.dart';

class TabletEducationWidget extends StatelessWidget {
  const TabletEducationWidget({
    required this.educations,
    super.key,
  });

  final List<Education> educations;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 1.0,
      ),
      itemCount: educations.length,
      itemBuilder: (context, index) => EducationContainer(
        education: educations[index],
      ),
    );
  }
}
