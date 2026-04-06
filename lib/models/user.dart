class UserData {
  final String id;
  final String fullName;
  final String email;
  final String password;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
  });
}

List<UserData> users = [
  UserData(
    id: '1',
    email: '1',
    fullName: 'Yousef Faiz Al-otaibi',
    password: '1',
  ),
  UserData(id: '2', email: '2', fullName: 'mohammed alotaibi', password: '2'),
];
