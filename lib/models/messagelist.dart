class Messagelist {
  Messagelist({
    required this.user,
    required this.message,
  });

  final User? user;
  final String? message;

  factory Messagelist.fromJson(Map<String, dynamic> json){
    return Messagelist(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      message: json["message"],
    );
  }

}

class User {
  User({
    required this.id,
    required this.email,
    required this.fullName,
  });

  final String? id;
  final String? email;
  final String? fullName;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      email: json["email"],
      fullName: json["fullName"],
    );
  }

}
