class Music{
  String musicId;
  String name; // 歌曲名称
  String singer; // 歌手
  int duration; // 时长，单位秒
  String image; // 图片
  String file; // 文件
  bool isLike;
  Map<String, double>? tags={"sad": 12, "happy":40, "normal":20};
  Music(
     this.musicId,
     this.name,
     this.singer,
     this.duration,
     this.image,
     this.file,
     this.isLike,
     {this.tags}
  );

  static Music example = Music(
      "114514",
      '未在播放', // 歌曲名称
      '群星', // 歌手
      233, // 时长，单位秒
      'https://thrconsortium.com/wp-content/uploads/2016/07/stock-vector-vector-musical-background-with-treble-clef-83565814-1024x1024.jpg', // 图片
      "audio/silence.mp3", // 文件
      true,
      );

  static Music generatedMusicExample = Music(
      "1000",
      '生成式疗愈音乐', // 歌曲名称
      'AIM', // 歌手
      233, // 时长，单位秒
      'https://thrconsortium.com/wp-content/uploads/2016/07/stock-vector-vector-musical-background-with-treble-clef-83565814-1024x1024.jpg', // 图片
      "audio/test3.mp3", // 文件
      true,
      );

  static List<Music> fakeMusicList = [
  Music(
    "001",
    'Believer',
    'Imagine Dragons',
    216,
    'https://picsum.photos/id/104/200/200',
    "audio/test.mp3",
    false,
    tags: {"富有活力的": 80, "鼓舞人心的": 60},
  ),
  Music(
    "002",
    'Blinding Lights',
    'The Weeknd',
    200,
    'https://picsum.photos/id/106/200/200',
    "audio/test1.mp3",
    true,
    tags: {"舞乐": 90, "快乐的": 75},
  ),
  Music(
    "003",
    'Someone Like You',
    'Adele',
    285,
    'https://picsum.photos/id/107/200/200',
    "audio/test2.mp3",
    false,
    tags: {"忧郁的": 95, "情绪化的": 80},
  ),
  Music(
    "004",
    'Thunder',
    'Imagine Dragons',
    187,
    'https://picsum.photos/id/108/200/200',
    "audio/test3.mp3",
    true,
    tags: {"富有活力的": 85, "激昂的": 70},
  ),
  Music(
    "005",
    'Havana',
    'Camila Cabello',
    217,
    'https://picsum.photos/id/109/200/200',
    "audio/test4.mp3",
    true,
    tags: {"平淡的": 90, "休憩的": 60},
  ),
  Music(
    "006",
    'Perfect',
    'Ed Sheeran',
    263,
    'https://picsum.photos/id/110/200/200',
    "audio/test5.mp3",
    true,
    tags: {"浪漫的": 95, "迟缓的": 80},
  ),
  Music(
    "007",
    'Bad Guy',
    'Billie Eilish',
    194,
    'https://picsum.photos/id/111/200/200',
    "audio/test6.mp3",
    false,
    tags: {"流行音乐": 85, "其他类型": 75},
  ),
  Music(
    "008",
    'Viva La Vida',
    'Coldplay',
    241,
    'https://picsum.photos/id/112/200/200',
    "audio/test7.mp3",
    true,
    tags: {"上扬的": 90, "合奏": 85},
  ),
  Music(
    "009",
    'Lose Yourself',
    'Eminem',
    326,
    'https://picsum.photos/id/113/200/200',
    "audio/test8.mp3",
    true,
    tags: {"鼓舞人心的": 100, "Rap": 95},
  ),
  Music(
    "010",
    'Shallow',
    'Lady Gaga, Bradley Cooper',
    215,
    'https://picsum.photos/id/114/200/200',
    "audio/test9.mp3",
    true,
    tags: {"双管乐": 90, "情绪化的": 85},
  ),
];

static List<Music> recentPlayedList = [];

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
        tags: json['tags'] != null ? Map<String, double>.from(json['tags']) : {},
    );
  }

}