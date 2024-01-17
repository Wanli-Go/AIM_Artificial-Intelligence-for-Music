import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_scatter/flutter_scatter.dart';
import 'package:kg_charts/kg_charts.dart';
import 'package:music_therapy/model/Music.dart';
import 'package:music_therapy/service/MusicService.dart';

import '../model/flutter_hashtags.dart';

class ScatterItem extends StatelessWidget {
  const ScatterItem(this.hashtag, this.index, {super.key});
  final FlutterHashtag hashtag;
  final int index;


  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: hashtag.size.toDouble(),
      color: hashtag.color,
    );

    return RotatedBox(
      quarterTurns: hashtag.rotated ? 1 : 0,
      child: Text(
        hashtag.hashtag,
        style: style,
      ),
    );
  }
}


class MusicDetailPage extends StatefulWidget {
  // 接收一个Music对象作为参数
  const MusicDetailPage({Key? key, required this.music}) : super(key: key);

  final Music music;

  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();

}

class _MusicDetailPageState extends State<MusicDetailPage>{

  final RecentlyPlayedMusicService musicService=RecentlyPlayedMusicService();

  late Music musicDetail;

  List<IndicatorModel> indicators=[];

  List<double> mapData=[];

  // 定义一个函数，用来将json数据中的tags转换成FlutterHashtag类的列表
  List<FlutterHashtag> convertTagsToHashtags(Map<String, double>? tags) {
    // 创建一个空的列表，用来存储转换后的标签
    List<FlutterHashtag> hashtags = [];
    // 创建一个随机数生成器
    Random random = Random();
    if(tags==null){
      return [];
    }
    // 遍历json数据中的tags
    tags.forEach((key, value) {
      // 根据标签名，创建一个FlutterHashtag对象
      FlutterHashtag hashtag = FlutterHashtag(
        key, // 标签名
        Color.fromRGBO(random.nextInt(256), random.nextInt(256),
            random.nextInt(256), 1), // 随机的颜色
        (value * 1000).toInt(), // map中的值×100
        random.nextBool(), // 随机的旋转状态
      );
      // 将创建的对象添加到列表中
      hashtags.add(hashtag);
    });
    // 返回列表
    return hashtags;
  }


  @override
  void initState(){
    super.initState();
    musicService.getMusicDetail(widget.music.musicId).then((value) {
      setState(() {
        musicDetail=value;
      });
    });


  }

  @override
  Widget build(BuildContext context) {


    List<FlutterHashtag> tags=convertTagsToHashtags(musicDetail.tags);
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < tags.length; i++) {
      widgets.add(ScatterItem(tags[i], i));
    }

    final screenSize = MediaQuery.of(context).size;
    final ratio = screenSize.width / screenSize.height;

    List<MapEntry<String, double>> sortedEntries = musicDetail.tags!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<MapEntry<String, double>> topSixEntries = sortedEntries.take(6).toList();

    for (var entry in topSixEntries) {
      String key = entry.key;
      double value = entry.value;
      print("Key: $key, Value: $value");
      indicators.add(IndicatorModel(entry.key,100));
      mapData.add(entry.value*1000);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 显示音乐图片
            Image.network(
              musicDetail.image,
              width: MediaQuery.of(context).size.width,
              height: 200,
              fit: BoxFit.cover,
            ),
            // 显示音乐名称和歌手
            ListTile(
              title: Text(
                musicDetail.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                musicDetail.singer,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),

            // 显示音乐标签

            SingleChildScrollView(
              child: RadarWidget(
                radarMap: RadarMapModel(
                  legend: [
                    LegendModel('',const Color(0XFF0EBD8D)),
                  ],
                  indicator: indicators,
                  data: [
                    MapDataModel(mapData),
                  ],
                  radius: 130,
                  duration: 2000,
                  shape: Shape.square,
                  maxWidth: 70,
                  line: LineModel(4),
                ),
                textStyle: const TextStyle(color: Colors.black,fontSize: 14),
                isNeedDrawLegend: true,
                lineText: (p,length) =>  "${(p*100~/length)}%",
                dilogText: (IndicatorModel indicatorModel,List<LegendModel> legendModels,List<double> mapDataModels) {
                  StringBuffer text = StringBuffer("");
                  for(int i=0;i<mapDataModels.length;i++){
                    text.write("${legendModels[i].name} : ${mapDataModels[i].toString()}");
                    if(i!=mapDataModels.length-1){
                      text.write("\n");
                    }
                  }
                  return text.toString();
                },
                outLineText: (data,max)=> "${data*100~/max}%",
              ),
            ),
            Container(
              height: 50,
            ),
            Center(
              child: FittedBox(
                child: Scatter(
                  fillGaps: true,
                  delegate: ArchimedeanSpiralScatterDelegate(ratio: ratio),
                  children: widgets,
                ),
              ),
            ),
            Container(
              height: 50,
            )

          ],
        ),
      ),
    );
  }
}

