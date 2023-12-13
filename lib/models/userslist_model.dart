
class Userlist {
  Userlist({
    required this.user,
  });

  User user;

  factory Userlist.fromJson(Map<String, dynamic> json) {
    return Userlist(
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  User({
    required this.email,
    required this.fullName,
    required this.receiverId,
  });

  String email;
  String fullName;
  String receiverId;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      fullName: json['fullName'],
      receiverId: json['receiverId'],
    );
  }
}