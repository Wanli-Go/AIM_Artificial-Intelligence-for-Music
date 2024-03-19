import 'package:flutter/material.dart';
import 'package:music_therapy/model/GlobalMusic.dart';
import 'package:music_therapy/model/Music.dart';
class GenericMusicList extends StatelessWidget {
  final List<Music> list;
  final double heightPercentage;
  final String headerline;
  const GenericMusicList(
      {super.key,
      required this.list,
      required this.heightPercentage,
      required this.headerline});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * heightPercentage, // 根据屏幕高度自动调整
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headerline,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 0, // Adjust the divider's thickness
                thickness: 1,
                color: Colors.grey.withOpacity(0.24),
              ),
              scrollDirection: Axis.vertical, // 纵向列表
              itemCount: list.length, // 列表项的数量
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SizedBox(
                    height: 52,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        list[index].image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  title: Text(
                    list[index].name,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.016, // 根据屏幕高度自动调整
                    ),
                  ),
                  subtitle: Text(
                    list[index].singer,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.013,
                    ),
                  ),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () {
                    // Update the global music to the one that was tapped
                    GlobalMusic.music = list[index];
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
