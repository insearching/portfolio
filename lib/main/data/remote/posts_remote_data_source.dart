import 'package:portfolio/main/data/mapper/firebase_raw_data_mapper.dart';
import 'package:portfolio/main/data/mapper/post_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/post.dart';

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
      final model = postRemoteModelFromDomain(post);
      await postsCollection.push().set(model.toJson());
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

    final rawData = event.snapshot.value;
    if (rawData == null) return [];

    try {
      final posts = firebaseRawToJsonMaps(rawData)
          .map(postRemoteModelFromJson)
          .map((m) => m.toDomain())
          .toList();

      print('Loaded ${posts.length} posts from Firebase');
      return posts;
    } catch (e) {
      print('Error parsing posts from Firebase: $e');
      rethrow;
    }
  }
}
