import 'package:flutter/material.dart';
import 'package:music_therapy/component/BottomMusicBar.dart';
import 'package:music_therapy/component/GenericMusicList.dart';
import 'package:music_therapy/model/Music.dart';
import 'package:music_therapy/service/MusicService.dart';
import 'package:particles_flutter/particles_flutter.dart';

class HomePage extends StatefulWidget {
  final List<Music> _recentlyPlayedMusicList = [];
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecentlyPlayedMusicService recentlyPlayedMusicService =
      RecentlyPlayedMusicService();

  // Added variables to track loading state
  bool _isLoadingRecentlyPlayedMusic = true;

  @override
  void initState() {
    super.initState();

    // Fetch recently played music only if the list is empty
    // This check prevents refetching data when navigating back to the page
    if (widget._recentlyPlayedMusicList.isEmpty) {
      recentlyPlayedMusicService.getRecent("1", 0, 10).then((value) {
        if (mounted) {
          setState(() {
            widget._recentlyPlayedMusicList.addAll(value);
            _isLoadingRecentlyPlayedMusic = false; // Update loading state
          });
        }
      });
    } else {
      // If the list is already populated, simply set loading to false
      _isLoadingRecentlyPlayedMusic = false;
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

                  const SizedBox(height: 5),

                  // Recently Played Music Section
                  _isLoadingRecentlyPlayedMusic
                      ? const Center(child:CircularProgressIndicator()) // Show loading indicator
                      : _buildRecentlyPlayedMusicSection(),
                ],
              ),
            ),
          ],
        ),

        // A bottom music bar to show currently playing music
        BottomMusicBar()
      ],
    );
  }

  @override
  void dispose() {
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
              height: MediaQuery.of(context).size.height * 0.35,
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
              height: 250,
              width: 250, // Set a fixed width to make the image circular
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
    return GenericMusicList(list: widget._recentlyPlayedMusicList, heightPercentage: 0.35, headerline: "常听疗愈音乐",);
  }
}
