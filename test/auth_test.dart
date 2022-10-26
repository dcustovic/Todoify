import 'package:notes_flutter/services/auth/auth_exceptions.dart';
import 'package:notes_flutter/services/auth/auth_provider.dart';
import 'package:notes_flutter/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final mockProvider = MockAuthProvider();

    test(
      "Should not be initialized to begin with",
      () {
        expect(mockProvider.isInitialized, false);
      },
    );

    test(
      "Cannot log out if not initialized",
      () {
        expect(mockProvider.logOut(),
            throwsA(const TypeMatcher<NotInitializedException>()));
      },
    );

    test(
      "Should be able to initialize",
      () async {
        await mockProvider.initialize();
        expect(mockProvider.isInitialized, true);
      },
    );

    test(
      "User should be null after initialization",
      () async {
        expect(mockProvider.currentUser, null);
      },
    );

    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await mockProvider.initialize();
        expect(mockProvider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("createUser should delegate to logIn function", () async {
      // testing wrong email address
      final badUser = mockProvider.createUser(
          email: 'wrong@email.com', password: "goodpassword");
      expect(badUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      // testing wrong password
      final badUserPassword = mockProvider.createUser(
          email: "good@email.com", password: "wrongpassword");
      expect(badUserPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      // testing correct credentials
      final user =
          await mockProvider.createUser(email: "test", password: "test");
      expect(mockProvider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logged in user should be able to get verified", () {
      mockProvider.sendEmailVerification();
      final user = mockProvider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to logout and login again", () async {
      await mockProvider.logOut();
      await mockProvider.logIn(email: "test", password: "test");
      final user = mockProvider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'wrong@email.com') throw UserNotFoundAuthException();
    if (password == "wrongpassword") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false, email: 'wrong@email.com');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, email: 'wrong@email.com');
    _user = newUser;
  }
}
