import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/login/login.dart';
import 'package:music_therapy/main/component/GenericMusicList.dart';
import 'package:music_therapy/main/model/Music.dart';
import 'package:music_therapy/main/model/user_data.dart';
import 'package:music_therapy/main/service/MusicService.dart';
import 'package:music_therapy/main/service/base_url.dart';
import 'package:palette_generator/palette_generator.dart'; // Add this line for Neumorphic design

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  // List of items for a more dynamic and modern-looking UI
  final List<Map<String, dynamic>> _items = [
    {'icon': Icons.access_time_filled, 'title': '最近播放'},
    {'icon': Icons.favorite, 'title': '我的收藏'},
    {
      'icon': Icons.receipt_outlined,
      'title': '生成记录',
    },
  ];

  PaletteGenerator? paletteGenerator;

  Future<void> _updatePaletteGenerator() async {
    paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(baseUrl + "/image/" + UserData.userImage),
      maximumColorCount: 1,
    );
    setState(() {});
  }

  bool isLoading = false;
  int pressedIndex = -1;
  void clickedButton(int index) async {
    setState(() {
      isLoading = true;
      pressedIndex = index;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
      pressedIndex = -1;
    });
  }

  @override
  void initState() {
    super.initState();
    _updatePaletteGenerator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            _buildHeader(), // Header section with avatar and nickname
            Expanded(child: _buildMenuList()), // Menu list section
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [
            (paletteGenerator != null)
                ? (paletteGenerator!.dominantColor?.color) ?? Colors.white
                : Colors.white,
            mainTheme
          ])),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(baseUrl + "/image/" + UserData.userImage),
          ),
          const SizedBox(
            width: 20,
            height: 100,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserData.username,
                  style: TextStyle(
                    color: NeumorphicTheme.defaultTextColor(context),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if(UserData.userIdentity == 1) Container(
                  decoration: BoxDecoration(
                    color: mainTheme,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(
                      color: Colors.redAccent,
                      spreadRadius: 1,
                      blurRadius: 1.5,
                      offset: Offset(0, 0.5), // changes position of shadow
                    )]
                  ),
                  width: 55,
                  child: const Row(
                    children: [
                      Icon(Icons.diamond_outlined,),
                      SizedBox(width: 3,),
                      Text("VIP")
                    ],
                  ),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () => {
                    // TODO: Edit Page
                  },
              icon: const Icon(Icons.navigate_next_rounded))
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return NeumorphicButton(
                style: NeumorphicStyle(
                    depth: 2, // Inward shadow for a "pressed" effect
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                    color: Colors.blueGrey.shade100.withOpacity(0.5)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          
                /* Pressed Logic */
                onPressed: () async {
                  clickedButton(index);
                  String userId = UserData.userId;
                  final List<Music> musicList = [];
                  musicList.addAll(switch (index) {
                    0 => await MusicService().getHistory(userId, 0, 20),
                    1 => await MusicService().getLiked(userId, 0, 20),
                    2 => await MusicService().getGeneratedRecord(userId),
                    int() => throw Exception('Invalid index'),
                  });
                  print(musicList);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(),
                        body: GenericMusicList(
                          list: musicList,
                          heightPercentage: 1,
                          upperWidget: Container(
                            padding: const EdgeInsets.all(
                                8), // Add some padding inside the container
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Set the fill color of the container (optional)
                              border: Border.all(color: mainTheme, width: 2),
                              borderRadius: BorderRadius.circular(
                                  12), // Set the border radius for rounded corners
                            ),
                            child: Text(
                              switch (index) {
                                0 => '最近播放',
                                1 => '我的收藏',
                                2 => '生成记录',
                                int() => throw Exception('Invalid index'),
                              },
                              style: TextStyle(
                                  fontSize: 30,
                                  color: mainTheme,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(item['icon'], color: mainTheme),
                      const SizedBox(width: 20),
                      Text(
                        item['title'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      (isLoading && index == pressedIndex)
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator())
                          : const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            UserData.logOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.8), // A visually distinct color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min, // Button adjusts to content
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '退出登陆',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 100,)
      ],
    );
  }
}
