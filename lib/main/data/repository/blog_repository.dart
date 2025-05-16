import 'package:firebase_database/firebase_database.dart';
import 'package:portfolio/main/data/post.dart';

const String postsCollectionName = 'posts';

class BlogRepository {
  BlogRepository({
    required this.databaseReference,
  });

  final DatabaseReference databaseReference;

  Future<void> addPost(Post post) async {
    final postsCollection = databaseReference.child(postsCollectionName);

    try {
      await postsCollection.push().set({
        'title': post.title,
        'description': post.description,
        'imageLink': post.imageLink,
        'link': post.link,
      });
      print('Post added successfully');
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  Future<List<Post>> readPosts() async {
    final postsCollection = databaseReference.child(postsCollectionName);
    final event = await postsCollection.once();

    if (event.snapshot.value == null) return [];

    try {
      final Map<dynamic, dynamic> rawData =
          event.snapshot.value as Map<dynamic, dynamic>;
      final List<Post> posts = [];

      rawData.forEach(
        (key, value) {
          if (value is Map) {
            posts.add(Post(
              title: value['title']?.toString() ?? '',
              description: value['description']?.toString() ?? '',
              imageLink: value['imageLink']?.toString() ?? '',
              link: value['link']?.toString() ?? '',
            ));
          }
        },
      );

      return posts;
    } catch (e) {
      print('Error parsing posts: $e');
      return [];
    }
  }
}
