import 'package:firebase_auth/firebase_auth.dart';

class FakeFirebaseAuth implements FirebaseAuth {
  FakeFirebaseAuth({User? currentUser}) : _currentUser = currentUser;

  User? _currentUser;

  bool signInCalled = false;
  bool signOutCalled = false;
  String? lastEmail;
  String? lastPassword;

  @override
  User? get currentUser => _currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signInCalled = true;
    lastEmail = email;
    lastPassword = password;

    final user = FakeUser(uid: 'fake_uid');
    _currentUser = user;
    return FakeUserCredential(user);
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
    _currentUser = null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserCredential implements UserCredential {
  FakeUserCredential(this._user);

  final User _user;

  @override
  User get user => _user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUser implements User {
  FakeUser({required this.uid});

  @override
  final String uid;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
