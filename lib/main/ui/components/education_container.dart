import 'package:flutter/material.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../utils/colors.dart';

class EducationContainer extends StatefulWidget {
  const EducationContainer({
    required this.education,
    Key? key,
  }) : super(key: key);

  final Education education;

  @override
  State<EducationContainer> createState() => _EducationContainerState();
}

class _EducationContainerState extends State<EducationContainer> {
  @override
  Widget build(BuildContext context) {
    final String? text = widget.education.text;
    final String? link = widget.education.link;
    final String? imageUrl = widget.education.imageUrl;

    bool isHovered = false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ElevatedContainer(
        onElevatedChanged: (value) {
          setState(() {
            isHovered = value;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.education.title,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.education.description,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16.0),
              const HorizontalDivider(),
              const SizedBox(height: 8.0),
              if (text != null) ...[
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyMedium,
                  softWrap: true,
                )
              ],
              if (imageUrl != null) ...[
                Image.network(imageUrl, width: 200),
              ],
              if (link != null) ...[
                const SizedBox(height: 8.0),
                InkWell(
                    child: Text('Check for more details',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isHovered ? UIColors.accent : UIColors.white,
                            )
                        ),
                    onTap: () => launchUrlString(link)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
