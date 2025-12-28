import 'package:flutter/material.dart';
import 'package:portfolio/main/di/service_locator.dart';
import 'package:portfolio/main/domain/model/device_info.dart';
import 'package:portfolio/main/domain/model/device_type.dart';
import 'package:portfolio/main/ui/blog/blog_container.dart';
import 'package:portfolio/main/ui/blog/blog_state.dart';

class BlogWidget extends StatelessWidget {
  const BlogWidget({
    required this.blogState,
    super.key,
  });

  final BlogState blogState;

  @override
  Widget build(BuildContext context) {
    final deviceType = locator<DeviceInfo>().deviceType;
    final isDesktop = deviceType == DeviceType.desktop;

    return Padding(
      padding: EdgeInsets.only(
          top: isDesktop ? 32.0 : 16.0, bottom: isDesktop ? 32.0 : 0.0),
      child: Column(
        children: [
          Text(
            'Blog',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32.0),
          if (blogState.status.isLoading)
            const CircularProgressIndicator()
          else if (blogState.status.isError)
            Center(
              child: Text(
                'Error loading posts',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            )
          else if (blogState.status.isSuccess)
            deviceType.isPhone
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: blogState.posts.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: BlogContainer(
                        post: blogState.posts[index],
                        horizontalPadding: 16.0,
                        imageHeight: 220.0,
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: deviceType.isDesktop ? 3 : 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: blogState.posts.length,
                    itemBuilder: (context, index) => BlogContainer(
                      post: blogState.posts[index],
                      horizontalPadding: 32.0,
                      imageHeight: 220.0,
                    ),
                  )
        ],
      ),
    );
  }
}
