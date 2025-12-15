import 'package:flutter/material.dart';
import 'package:portfolio/main/domain/model/education.dart';
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
    final String? imagePath = education.imageUrl;

    return ElevatedContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            education.title,
            style: Theme.of(context).textTheme.bodyLarge,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 8.0),
          Text(
            education.description,
            style: Theme.of(context).textTheme.bodyMedium,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 16.0),
          const HorizontalDivider(),
          const SizedBox(height: 16.0),
          if (text != null) ...[
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
          ],
          if (imagePath != null && imagePath.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                onTap: link != null ? () => launchUrlString(link) : null,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}
