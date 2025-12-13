import 'package:portfolio/main/data/post.dart';
import 'package:portfolio/main/data/typedefs.dart';

/// Remote static_data source for Posts
/// Handles all Firebase Realtime Database operations for posts
abstract class PostsRemoteDataSource {
  Future<void> addPost(Post post);

  Future<List<Post>> readPosts();
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  PostsRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'posts';

  @override
  Future<void> addPost(Post post) async {
    final postsCollection = firebaseDatabaseReference.child(_collectionName);

    try {
      await postsCollection.push().set({
        'title': post.title,
        'description': post.description,
        'imageLink': post.imageLink,
        'link': post.link,
      });
      print('Post added successfully to Firebase');
    } catch (e) {
      print('Error adding post to Firebase: $e');
      rethrow;
    }
  }

  @override
  Future<List<Post>> readPosts() async {
    final postsCollection = firebaseDatabaseReference.child(_collectionName);
    final event = await postsCollection.once();

    if (event.snapshot.value == null) return [];

    try {
      final rawData = event.snapshot.value;
      final List<Post> posts = [];

      // Handle both Map (from .push()) and List formats
      if (rawData is Map) {
        // Firebase returns Map when using .push()
        for (var entry in rawData.entries) {
          final value = entry.value;
          if (value is Map) {
            posts.add(
              Post(
                title: value['title']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                imageLink: value['imageLink']?.toString() ?? '',
                link: value['link']?.toString() ?? '',
              ),
            );
          }
        }
      } else if (rawData is List) {
        // Handle List format (if data is structured as array)
        for (var value in rawData) {
          if (value is Map) {
            posts.add(
              Post(
                title: value['title']?.toString() ?? '',
                description: value['description']?.toString() ?? '',
                imageLink: value['imageLink']?.toString() ?? '',
                link: value['link']?.toString() ?? '',
              ),
            );
          }
        }
      }

      print('Loaded ${posts.length} posts from Firebase');
      return posts;
    } catch (e) {
      print('Error parsing posts from Firebase: $e');
      rethrow;
    }
  }
}
