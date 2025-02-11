import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
      ),
      title: 'Appinio Video Player Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _videoPlayerController, _videoPlayerController2, _videoPlayerController3;

  late CustomVideoPlayerController _customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  late final CustomVideoPlayerSettings _customVideoPlayerSettings;

  final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings = CustomVideoPlayerWebSettings(
    src: longVideo,
  );

  ChromeCastController? castController;

  @override
  void initState() {
    super.initState();
    _customVideoPlayerSettings = CustomVideoPlayerSettings(
      showSeekButtons: true,
      castButton: ChromeCastButton(
        size: 25,
        onButtonCreated: (controller) {
          castController = controller;
          castController?.addSessionListener();
        },
        onSessionStarted: () {
          log("in app started");
          castController?.onProgressEvent().listen((event) {
            log("in app progress ${event.inMilliseconds}");
          });
          castController?.loadMedia(
            url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            position: 30000,
            autoplay: true,
            title: "Spider-Man: No Way Home",
            description:
                "Peter Parker is unmasked and no longer able to separate his normal life from the high-stakes of being a super-hero. When he asks for help from Doctor Strange the stakes become even more dangerous, forcing him to discover what it truly means to be Spider-Man.",
            image: "https://terrigen-cdn-dev.marvel.com/content/prod/1x/marvsmposterbk_intdesign.jpg",
            type: ChromeCastMediaType.movie,
            subtitles: [
              ChromeCastSubtitle(
                id: 1,
                language: "en-US",
                name: "English",
                source: "https://cc.2cdns.com/3e/62/3e62d0109500abf55acf229a0599a20d/3e62d0109500abf55acf229a0599a20d.vtt",
              ),
              ChromeCastSubtitle(
                id: 2,
                language: "ar",
                name: "Arabic",
                source: "https://cc.2cdns.com/91/bd/91bdc91ffff0906bd54f0711eb3e786f/91bdc91ffff0906bd54f0711eb3e786f.vtt",
              ),
            ],
          );
        },
      ),
    );

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(longVideo),
    )..initialize().then((value) => setState(() {}));
    _videoPlayerController2 = VideoPlayerController.networkUrl(Uri.parse(video240));
    _videoPlayerController3 = VideoPlayerController.networkUrl(Uri.parse(video480));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      additionalVideoSources: {
        "240p": _videoPlayerController2,
        "480p": _videoPlayerController3,
        "720p": _videoPlayerController,
      },
    );

    _customVideoPlayerWebController = CustomVideoPlayerWebController(
      webVideoPlayerSettings: _customVideoPlayerWebSettings,
    );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Appinio Video Player"),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            kIsWeb
                ? Expanded(
                    child: CustomVideoPlayerWeb(
                      customVideoPlayerWebController: _customVideoPlayerWebController,
                    ),
                  )
                : CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController,
                  ),
            CupertinoButton(
              child: const Text("Play Fullscreen"),
              onPressed: () {
                if (kIsWeb) {
                  _customVideoPlayerWebController.setFullscreen(true);
                  _customVideoPlayerWebController.play();
                } else {
                  _customVideoPlayerController.setFullscreen(true);
                  _customVideoPlayerController.videoPlayerController.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

String videoUrlLandscape = "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
String videoUrlPortrait = 'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
String longVideo = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";

String video720 = "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4";

String video480 = "https://www.sample-videos.com/video123/mp4/480/big_buck_bunny_480p_10mb.mp4";

String video240 = "https://www.sample-videos.com/video123/mp4/240/big_buck_bunny_240p_10mb.mp4";
