class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'student' | 'instructor' | 'admin'
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final List<String> enrolledCourseIds;
  final bool isDemoUser;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    this.enrolledCourseIds = const [],
    this.isDemoUser = false,
  });

  bool get isStudent => role == 'student';
  bool get isInstructor => role == 'instructor';
  bool get isAdmin => role == 'admin';

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? role,
    String? photoUrl,
    String? bio,
    DateTime? createdAt,
    List<String>? enrolledCourseIds,
    bool? isDemoUser,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      isDemoUser: isDemoUser ?? this.isDemoUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'enrolledCourseIds': enrolledCourseIds,
      'isDemoUser': isDemoUser,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Learner',
      role: map['role'] as String? ?? 'student',
      photoUrl: map['photoUrl'] as String?,
      bio: map['bio'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      enrolledCourseIds: List<String>.from(map['enrolledCourseIds'] as List? ?? []),
      isDemoUser: map['isDemoUser'] as bool? ?? false,
    );
  }
}
