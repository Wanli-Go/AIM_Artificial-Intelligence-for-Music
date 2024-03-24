class UserData{
  static String username = "清心";
  static String userPhone = "1234134245";
  static int userIdentity = 1;
  static String userIll = "/";
  static String userImage = "https://picsum.photos/id/104/200/200";
  static String userId = "";
  static String tokens = "";

  static void logOut(){
    username = "";
    userPhone = "";
    userIdentity = 0;
    userIll = "";
    userImage = "";
    userId = "";
    tokens = "";
  }
}