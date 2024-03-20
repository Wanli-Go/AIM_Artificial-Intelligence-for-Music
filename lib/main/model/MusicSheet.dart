// 定义一个MusicSheet类，包含三个属性：musicSheetId, image, musicSheetName


class MusicSheet {
  String musicSheetId;
  String? image;
  String musicSheetName;

  // 定义一个构造函数，接收三个参数
  MusicSheet(this.musicSheetId, this.image, this.musicSheetName);

  static MusicSheet example = MusicSheet('114514', null, "默认歌单");

  // 定义一个fromJson方法，接收一个json对象，返回一个MusicSheet对象
  factory MusicSheet.fromJson(dynamic json) {
    return MusicSheet(
      json['musicSheetId'] as String,
      json['image'] as String?,
      json['musicSheetName'] as String,
    );
  }

  @override
  String toString() {
    return 'MusicSheet{id: $musicSheetId, name: $musicSheetName, email: $image}';
  }
}



