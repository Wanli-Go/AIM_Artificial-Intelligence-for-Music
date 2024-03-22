import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/model/GlobalMusic.dart';
import 'package:music_therapy/main/model/Music.dart';

class GenericMusicList extends StatefulWidget {
  final List<Music> list;
  final double heightPercentage;
  const GenericMusicList(
      {super.key,
      required this.list,
      required this.heightPercentage,});

  @override
  State<GenericMusicList> createState() => _GenericMusicListState();
}

class _GenericMusicListState extends State<GenericMusicList> {
  AudioPlayer audioPlayer = GlobalMusic.globalAudioPlayer;

  late int clickedIndex;

  @override
  void initState() {
    super.initState();
    clickedIndex = GlobalMusic.index;
    // 监听音频播放器的时长变化
    audioPlayer.onDurationChanged.listen((dur) {
      if (mounted) {
        setState(() {
          clickedIndex = GlobalMusic.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * widget.heightPercentage, // 根据屏幕高度自动调整
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 0, // Adjust the divider's thickness
                thickness: 1,
                color: Colors.grey.withOpacity(0.24),
              ),
              scrollDirection: Axis.vertical, // 纵向列表
              itemCount: widget.list.length, // 列表项的数量
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    height: 52,
                    width: 52,
                    child: Container(
                      decoration: (index != clickedIndex) // Is playing or not
                      ? null
                      : BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: mainTheme.withOpacity(0.6),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          widget.list[index].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.list[index].name,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.016, // 根据屏幕高度自动调整
                    ),
                  ),
                  subtitle: Text(
                    widget.list[index].singer,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.013,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {
                    // Update the global music to the one that was tapped
                    GlobalMusic.music = widget.list[index];
                    GlobalMusic.index = index;
                    GlobalMusic.musicList = widget.list;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
