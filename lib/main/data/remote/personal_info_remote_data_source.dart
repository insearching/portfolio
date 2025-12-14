import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/main/data/personal_info.dart';
import 'package:portfolio/main/data/typedefs.dart';
import 'package:portfolio/utils/env_config.dart';

/// Remote data source for PersonalInfo
/// Handles all Firebase Realtime Database operations for personal info
abstract class PersonalInfoRemoteDataSource {
  Future<PersonalInfo?> readPersonalInfo();

  Future<void> writePersonalInfo(PersonalInfo info);
}

class PersonalInfoRemoteDataSourceImpl implements PersonalInfoRemoteDataSource {
  PersonalInfoRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
  });

  final FirebaseDatabaseReference firebaseDatabaseReference;
  static const String _collectionName = 'personal_info';

  @override
  Future<PersonalInfo?> readPersonalInfo() async {
    final personalInfoRef = firebaseDatabaseReference.child(_collectionName);
    final event = await personalInfoRef.once();

    if (event.snapshot.value == null) return null;

    try {
      final rawData = event.snapshot.value;

      if (rawData is Map) {
        final data = Map<String, dynamic>.from(rawData);
        print('Loaded personal info from Firebase');
        return PersonalInfo.fromJson(data);
      }

      print('Unexpected data format for personal info in Firebase');
      return null;
    } catch (e) {
      print('Error parsing personal info from Firebase: $e');
      rethrow;
    }
  }

  @override
  Future<void> writePersonalInfo(PersonalInfo info) async {
    try {
      // Authenticate before writing
      final auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      // If not authenticated, sign in with credentials from .env
      if (currentUser == null) {
        print('Authenticating with Firebase...');
        await auth.signInWithEmailAndPassword(
          email: EnvConfig.firebaseEmail,
          password: EnvConfig.firebasePassword,
        );
        print('Firebase authentication successful');
      }

      // Write data to Firebase Realtime Database
      final personalInfoRef = firebaseDatabaseReference.child(_collectionName);
      await personalInfoRef.set(info.toJson());
      print('Personal info written to Firebase successfully');

      // Sign out after writing for security
      await auth.signOut();
      print('Signed out from Firebase');
    } catch (e) {
      print('Error writing personal info to Firebase: $e');
      rethrow;
    }
  }
}
