import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController videoController;
  bool isPlaying =  false;

  @override
  void initState() {
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.videoUrl)..initialize().then((value) => {
      videoController.setVolume(1)
    });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 19,
      child: Stack(
        children: [
          CachedVideoPlayer(videoController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              style: const ButtonStyle(
                iconSize: MaterialStatePropertyAll(30)
              ),
              onPressed: (){
              if(isPlaying){
                videoController.pause();
              }
              else
                {
                  videoController.play();
                }
              setState(() {
                isPlaying = !isPlaying;
              });
            }, icon: isPlaying? const Icon(Icons.pause_circle_outline) : const Icon(  Icons.play_circle_outline),),
          )
        ],
      ),
    );
  }
}
