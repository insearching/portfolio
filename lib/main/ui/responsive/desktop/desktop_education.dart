import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/domain/model/education.dart';
import 'package:portfolio/main/ui/components/education_container.dart';

class DesktopEducationWidget extends StatelessWidget {
  const DesktopEducationWidget({
    required this.educations,
    Key? key,
  }) : super(key: key);

  final List<Education> educations;

  @override
  Widget build(BuildContext context) {
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
  }
}
