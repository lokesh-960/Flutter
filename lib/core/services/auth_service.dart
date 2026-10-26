import 'dart:async';
import 'package:uuid/uuid.dart';
import '../errors/app_exception.dart';
import '../../features/auth/models/user_model.dart';
import '../../seed/seed_data.dart';
import 'local_storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  final StreamController<UserModel?> _userStreamController =
      StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get authStateChanges => _userStreamController.stream;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // In-memory registered user directory for the session
  final Map<String, Map<String, dynamic>> _userCredentials = {
    'student@dlms.edu': {
      'password': 'Password123!',
      'user': SeedData.sampleUsers.firstWhere((u) => u.role == 'student'),
    },
    'instructor@dlms.edu': {
      'password': 'Password123!',
      'user': SeedData.sampleUsers.firstWhere((u) => u.role == 'instructor'),
    },
    'admin@dlms.edu': {
      'password': 'Password123!',
      'user': SeedData.sampleUsers.firstWhere((u) => u.role == 'admin'),
    },
  };

  Future<void> initialize() async {
    final storage = await LocalStorageService.getInstance();
    final savedUser = storage.getUser();
    if (savedUser != null) {
      _currentUser = savedUser;
      _userStreamController.add(_currentUser);
    }
  }

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Network simulation

    final cleanEmail = email.trim().toLowerCase();
    final record = _userCredentials[cleanEmail];

    if (record == null) {
      throw AuthException(
        'No user account found with this email address. Please register.',
        code: 'USER_NOT_FOUND',
      );
    }

    if (record['password'] != password) {
      throw AuthException(
        'Incorrect password. Please verify your credentials and try again.',
        code: 'WRONG_PASSWORD',
      );
    }

    final user = record['user'] as UserModel;
    _currentUser = user;

    final storage = await LocalStorageService.getInstance();
    await storage.saveUser(user);

    _userStreamController.add(_currentUser);
    return user;
  }

  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String role,
    String? bio,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final cleanEmail = email.trim().toLowerCase();

    // Security rule: Never allow regular users to self-assign admin role!
    if (role == 'admin') {
      throw PermissionException(
        'Administrative roles cannot be assigned through public registration.',
      );
    }

    if (_userCredentials.containsKey(cleanEmail)) {
      throw AuthException(
        'An account with this email address already exists.',
        code: 'EMAIL_ALREADY_IN_USE',
      );
    }

    final newUser = UserModel(
      uid: const Uuid().v4(),
      email: cleanEmail,
      displayName: displayName.trim(),
      role: role == 'instructor' ? 'instructor' : 'student',
      bio: bio?.trim(),
      createdAt: DateTime.now(),
      enrolledCourseIds: const [],
      isDemoUser: false,
    );

    _userCredentials[cleanEmail] = {
      'password': password,
      'user': newUser,
    };

    _currentUser = newUser;
    final storage = await LocalStorageService.getInstance();
    await storage.saveUser(newUser);

    _userStreamController.add(_currentUser);
    return newUser;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final cleanEmail = email.trim().toLowerCase();
    if (!_userCredentials.containsKey(cleanEmail)) {
      throw AuthException(
        'No account found with this email address.',
        code: 'USER_NOT_FOUND',
      );
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return;
    final updated = _currentUser!.copyWith(
      displayName: displayName ?? _currentUser!.displayName,
      bio: bio ?? _currentUser!.bio,
      photoUrl: photoUrl ?? _currentUser!.photoUrl,
    );
    _currentUser = updated;

    final storage = await LocalStorageService.getInstance();
    await storage.saveUser(updated);

    if (_userCredentials.containsKey(_currentUser!.email)) {
      _userCredentials[_currentUser!.email]!['user'] = updated;
    }

    _userStreamController.add(_currentUser);
  }

  Future<void> signOut() async {
    _currentUser = null;
    final storage = await LocalStorageService.getInstance();
    await storage.clearUser();
    _userStreamController.add(null);
  }

  void dispose() {
    _userStreamController.close();
  }
}
