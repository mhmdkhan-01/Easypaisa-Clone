import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SendingAnimation extends StatefulWidget {
  final Widget nextScreen;

  const SendingAnimation({super.key, required this.nextScreen});

  @override
  State<SendingAnimation> createState() => _SendingAnimationState();
}

class _SendingAnimationState extends State<SendingAnimation> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // video
    _controller = VideoPlayerController.asset("assets/sendingAnimation.mp4")
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true)
      ..play();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => widget.nextScreen),
          (route) => route.isFirst,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _controller.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          : Center(child: Container(color: Colors.white)),
    );
  }
}
