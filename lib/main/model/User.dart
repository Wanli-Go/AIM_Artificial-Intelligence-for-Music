class User {
  String userId;
  String userName;
  String? image;
  String userAccount;
  int userIdentity;
  String userMail;
  String? ill;

  User(this.userId, this.userName, this.image, this.userAccount,
      this.userIdentity, this.userMail, this.ill);

  // 定义一个fromJson方法，接收一个json对象，返回一个User对象
  factory User.fromJson(dynamic json) {
    return User(
        json['userId'] as String,
        json['userName'] as String,
        json['image'] as String?,
        json['userAccount'] as String,
        json['userIdentity'] as int,
        json['userMail'] as String,
        json['ill'] as String?);
  }

  @override
  String toString() {
    return 'User{id: $userId, name: $userName, image: $image, user: $userAccount, userIdentity: $userIdentity, userMail: $userMail, ill: $ill}';
  }
}