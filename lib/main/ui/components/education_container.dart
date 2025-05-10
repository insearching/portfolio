import 'package:flutter/material.dart';
import 'package:portfolio/main/data/education.dart';
import 'package:portfolio/main/ui/components/elevated_container.dart';
import 'package:portfolio/main/ui/components/horizontal_divider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EducationContainer extends StatelessWidget {
  const EducationContainer({
    required this.education,
    Key? key,
  }) : super(key: key);

  final Education education;

  @override
  Widget build(BuildContext context) {
    final String? text = education.text;
    final String? link = education.link;
    final String? imageUrl = education.imageUrl;

    return ElevatedContainer(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              education.title,
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              education.description,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16.0),
            const HorizontalDivider(),
            const SizedBox(height: 24.0),
            if (text != null) ...[
              Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium,
                softWrap: true,
              )
            ],
            if (imageUrl != null) ...[
              InkWell(
                onTap: link != null ? () => launchUrlString(link) : null,
                child: Image(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
