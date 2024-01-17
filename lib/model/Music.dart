class Music{
  String musicId;
  String name; // 歌曲名称
  String singer; // 歌手
  int duration; // 时长，单位秒
  String image; // 图片
  String file; // 文件
  bool isLike;
  Map<String,double>? tags={"sad": 12,"happy":40,"normal":20};
  Music(
     this.musicId,
     this.name,
     this.singer,
     this.duration,
     this.image,
     this.file,
     this.isLike,
     this.tags
  );

  @override
  String toString() {
    return 'Music{name: $name, singer: $singer, duration: $duration, image: $image, file: $file, isLike: $isLike, tags: $tags}';
  }

  factory Music.fromJson(dynamic json) {
    return Music(
        json['musicId'] as String,
        json['name'] as String,
        json['singer'] as String,
        json['duration'] as int,
        json['image'] as String,
        json['file'] as String,
        json['isLike'] as bool,
      json['tags'] != null ? Map<String, double>.from(json['tags']) : {},
    );
  }

}