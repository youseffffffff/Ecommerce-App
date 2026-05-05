class UserData {
  final String id;
  final String userName;
  final String email;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.email,
    required this.userName,
    required this.createdAt,
  });

  // Convert UserData to JSON
  Map<String, dynamic> toMap() => {
    'id': id,
    'userName': userName,
    'email': email,
    'createdAt': createdAt.toIso8601String(),
  };

  // Create UserData from JSON
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
