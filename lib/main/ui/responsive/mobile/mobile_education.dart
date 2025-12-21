import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/ui/components/education_container.dart';

class MobileEducationWidget extends StatelessWidget {
  const MobileEducationWidget({
    required this.educations,
    super.key,
  });

  final List<Education> educations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: educations.length,
      itemBuilder: (context, index) => EducationContainer(
        education: educations[index],
      ),
    );
  }
}
