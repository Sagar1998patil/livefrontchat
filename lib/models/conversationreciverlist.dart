class ConversationreciverData {
  ConversationreciverData({
    required this.user,
    required this.conversationId,
  });

  final User? user;
  final String? conversationId;

  factory ConversationreciverData.fromJson(Map<String, dynamic> json){
    return ConversationreciverData(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      conversationId: json["conversationId"],
    );
  }

}

class User {
  User({
    required this.receiverId,
    required this.email,
    required this.fullName,
  });

  final String? receiverId;
  final String? email;
  final String? fullName;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      receiverId: json["receiverId"],
      email: json["email"],
      fullName: json["fullName"],
    );
  }

}
