import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:music_therapy/app_theme.dart';
import 'package:music_therapy/main/component/BottomMusicBar.dart';
import 'package:music_therapy/main/component/GenericMusicList.dart';
import 'package:music_therapy/main/model/Music.dart';
import 'package:music_therapy/main/service/MusicService.dart';
import 'package:particles_flutter/particles_flutter.dart';

class HomePage extends StatefulWidget {
  final List<Music> _recentlyPlayedMusicList = [];
  final List<Music> _likedMusicList = [];
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  final MusicService homePageMusicService =
      MusicService();

  // Added variables to track loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // Fetch recently played music only if the list is empty
    // This check prevents refetching data when navigating back to the page
    if (widget._recentlyPlayedMusicList.isEmpty ||
        widget._likedMusicList.isEmpty) {
      homePageMusicService.getRecent("1", 0, 10).then((value) {
        if (mounted) {
          setState(() {
            widget._recentlyPlayedMusicList.addAll(value);
            _isLoading = false; // Update loading state
          });
        }
      });
      homePageMusicService.getLiked("1", 0, 10).then((value) {
        if (mounted) {
          setState(() {
            widget._likedMusicList.addAll(value);
            _isLoading = false; // Update loading state
          });
        }
      });
    } else {
      // If the list is already populated, simply set loading to false
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter, // For displaying the bottom music bar
      children: [
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildParticleView(),

                  // Recently Played Music Section
                  _isLoading
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Show loading indicator
                      : _buildRecentlyPlayedMusicSection(),
                ],
              ),
            ),
          ],
        ),

        // A bottom music bar to show currently playing music
        const BottomMusicBar()
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildParticleView() {
    return Center(
      child: Container(
        key: UniqueKey(),
        child: Stack(alignment: Alignment.center, children: [
          Center(
            child: CircularParticle(
              // key: UniqueKey(),
              awayRadius: 80,
              numberOfParticles: 130,
              speedOfParticles: 0.5,
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              onTapAnimation: true,
              particleColor: Colors.white.withAlpha(150),
              awayAnimationDuration: const Duration(milliseconds: 1000),
              maxParticleSize: 4.5,
              isRandSize: true,
              isRandomColor: true,
              randColorList: [
                Colors.deepOrange.shade300.withAlpha(210),
                const Color.fromARGB(255, 231, 218, 190).withAlpha(210),
                Colors.yellow.withAlpha(100),
              ],
              awayAnimationCurve: Curves.easeInOutBack,
              enableHover: true,
              hoverColor: Colors.white,
              hoverRadius: 30,
              connectDots: false, //not recommended
            ),
          ),
          Center(
            child: SizedBox(
              height: 220,
              width: 220, // Set a fixed width to make the image circular
              child: ClipOval(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const RadialGradient(
                      center: Alignment.center,
                      radius: 0.5,
                      colors: [Colors.black, Colors.transparent],
                      stops: [
                        0.73,
                        1.0
                      ], // Adjust these stops for desired effect
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode
                      .dstIn, // This blend mode will fade out the edges
                  child:
                      Image.asset("assets/image/logo.png", fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildRecentlyPlayedMusicSection() {
    return Column(
      children: [
        SizedBox(
          child: TabBar(
            dividerHeight: 0.5,
            labelStyle: const TextStyle(
              fontFamily: "Starrail",
              fontWeight: FontWeight.bold
            ),
            indicator: BoxDecoration(
              color: Colors.white, // Light grey background
              border: Border.all(
                color: mainTheme.withOpacity(0.7),
                width: 1,
              ),
              borderRadius:
                  const BorderRadius.all(Radius.circular(10)), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  spreadRadius: 0.5,
                  blurRadius: 0.7,
                  offset: const Offset(0, -0.5), // Changes shadow position
                ),
              ],
            ),
            labelColor: mainTheme,
            tabs: const [
              Padding(
                padding: EdgeInsets.only(left: 34, right: 34),
                child: Tab(
                  text: "常听音乐",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 34, right: 34),
                child: Tab(
                  text: "收藏音乐",
                ),
              )
            ],
            controller: _tabController,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.33,
          child: TabBarView(controller: _tabController, children: [
            GenericMusicList(
                list: widget._recentlyPlayedMusicList, heightPercentage: 0.35),
            GenericMusicList(
                list: widget._recentlyPlayedMusicList, heightPercentage: 0.35),
          ]),
        )
      ],
    );
  }
}
