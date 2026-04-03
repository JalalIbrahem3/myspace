import 'package:myspace/services/auth/auth_exception.dart';
import 'package:myspace/services/auth/auth_provider.dart';
import 'package:myspace/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isIntialized, false);
    });
  });
}

class NotIntializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isIntialized = false;
  bool get isIntialized => _isIntialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isIntialized) throw NotIntializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isIntialized = true;

  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
    }) {
      if (!isIntialized) throw NotIntializedException();
      if (email =='foo@bar.com') throw UserNotFoundAuthException();
      if(password == 'foobar') throw WrongPasswordAuthException();
      const user = AuthUser(false);
      _user = user; 
      return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isIntialized) throw NotIntializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isIntialized) throw NotIntializedException();
    final user = _user;
    if(user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(true);
    _user = newUser;


  }
}
