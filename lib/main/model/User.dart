class User{
  String userId;
  String userName;
  String? image;
  String userAccount;

  User(this.userId,this.userName, this.image,this.userAccount);

  // 定义一个fromJson方法，接收一个json对象，返回一个MusicSheet对象
  factory User.fromJson(dynamic json) {
    return User(
      json['userId'] as String,
      json['userName'] as String,
      json['image'] as String?,
      json['userAccount'] as String
    );
  }

  @override
  String toString() {
    return 'User{id: $userId, name: $userName, image: $image, user: $userAccount}';
  }

}