import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/ui/resume/education_container.dart';
import 'package:provider/provider.dart';

class EducationWidget extends StatelessWidget {
  const EducationWidget({
    required this.educations,
    super.key,
  });

  final List<Education> educations;

  @override
  Widget build(BuildContext context) {
    final deviceType = context.read<DeviceInfo>().deviceType;

    if (deviceType.isPhone) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: educations.length,
        itemBuilder: (context, index) => EducationContainer(
          education: educations[index],
        ),
      );
    } else if (deviceType.isDesktop) {
      // Group educations into rows of 3
      final List<List<Education>> rows = [];
      for (int i = 0; i < educations.length; i += 3) {
        final end = (i + 3 < educations.length) ? i + 3 : educations.length;
        rows.add(educations.sublist(i, end));
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final double spacing = 16.0;
          final double totalSpacing = spacing * 2; // spacing between 3 items
          final double itemWidth = (constraints.maxWidth - totalSpacing) / 3;

          return Column(
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < row.length; i++) ...[
                        if (i > 0) const SizedBox(width: 16.0),
                        SizedBox(
                          width: itemWidth,
                          child: EducationContainer(
                            education: row[i],
                          ),
                        ),
                      ],
                      // Fill remaining space if less than 3 items in row
                      if (row.length < 3) Expanded(child: Container()),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      );
    } else {
      // Tablet
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
}
