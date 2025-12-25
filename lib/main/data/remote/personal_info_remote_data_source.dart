import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio/main/data/mapper/personal_info_remote_model_mapper.dart';
import 'package:portfolio/main/data/utils/typedefs.dart';
import 'package:portfolio/main/domain/model/personal_info.dart';
import 'package:portfolio/utils/env_config.dart';
import 'package:portfolio/core/logger/app_logger.dart';

/// Remote data source for PersonalInfo
/// Handles all Firebase Realtime Database operations for personal info
abstract class PersonalInfoRemoteDataSource {
  Future<PersonalInfo?> readPersonalInfo();

  Future<void> writePersonalInfo(PersonalInfo info);
}

class PersonalInfoRemoteDataSourceImpl implements PersonalInfoRemoteDataSource {
  PersonalInfoRemoteDataSourceImpl({
    required this.firebaseDatabaseReference,
    FirebaseAuth? firebaseAuth,
    String? firebaseEmail,
    String? firebasePassword,
    required this.logger,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseEmail = firebaseEmail,
        _firebasePassword = firebasePassword;

  final FirebaseDatabaseReference firebaseDatabaseReference;
  final AppLogger logger;
  final FirebaseAuth? _firebaseAuth;
  final String? _firebaseEmail;
  final String? _firebasePassword;

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
        logger.debug('Loaded personal info from Firebase',
            'PersonalInfoRemoteDataSource');

        final model = personalInfoRemoteModelFromJson(data);
        return model.toDomain();
      }

      logger.debug('Unexpected data format for personal info in Firebase',
          'PersonalInfoRemoteDataSource');
      return null;
    } catch (e, stackTrace) {
      logger.error('Error parsing personal info from Firebase', e, stackTrace,
          'PersonalInfoRemoteDataSource');
      rethrow;
    }
  }

  @override
  Future<void> writePersonalInfo(PersonalInfo info) async {
    try {
      // Authenticate before writing
      final auth = _firebaseAuth ?? FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      // If not authenticated, sign in with credentials from .env
      if (currentUser == null) {
        logger.debug(
            'Authenticating with Firebase...', 'PersonalInfoRemoteDataSource');
        await auth.signInWithEmailAndPassword(
          email: _firebaseEmail ?? EnvConfig.firebaseEmail,
          password: _firebasePassword ?? EnvConfig.firebasePassword,
        );
        logger.debug('Firebase authentication successful',
            'PersonalInfoRemoteDataSource');
      }

      // Write data to Firebase Realtime Database
      final personalInfoRef = firebaseDatabaseReference.child(_collectionName);
      final model = personalInfoRemoteModelFromDomain(info);
      await personalInfoRef.set(model.toJson());
      logger.debug('Personal info written to Firebase successfully',
          'PersonalInfoRemoteDataSource');

      // Sign out after writing for security
      await auth.signOut();
      logger.debug('Signed out from Firebase', 'PersonalInfoRemoteDataSource');
    } catch (e, stackTrace) {
      logger.error('Error writing personal info to Firebase', e, stackTrace,
          'PersonalInfoRemoteDataSource');
      rethrow;
    }
  }
}
