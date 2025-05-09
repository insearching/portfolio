import 'package:flutter/cupertino.dart';
import 'package:portfolio/main/data/device_type.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/ui/components/education_container.dart';

class EducationWidget extends StatefulWidget {
  const EducationWidget({
    required this.educations,
    required this.deviceType,
    Key? key,
  }) : super(key: key);

  final List<Education> educations;
  final DeviceType deviceType;

  @override
  State<EducationWidget> createState() => _EducationWidgetState();
}

class _EducationWidgetState extends State<EducationWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.deviceType == DeviceType.phone) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.educations.map(
                (education) =>
                EducationContainer(education: education),
          )
              .toList(),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.educations
                    .asMap()
                    .entries
                    .where((entry) => entry.key % 3 == 0)
                    .map((entry) => EducationContainer(
                  education: entry.value,
                ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 24.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.educations
                    .asMap()
                    .entries
                    .where((entry) => entry.key % 3 == 1)
                    .map((entry) => EducationContainer(
                  education: entry.value,
                ))
                    .toList(),
              ),
            ),
            const SizedBox(width: 24.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.educations
                    .asMap()
                    .entries
                    .where((entry) => entry.key % 3 == 2)
                    .map((entry) => EducationContainer(
                  education: entry.value,
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}