import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payx/screens/logged_in_home_screen.dart';
import 'package:video_player/video_player.dart';

class FlashscreenInto extends StatefulWidget {
  const FlashscreenInto({super.key});

  @override
  State<FlashscreenInto> createState() => _FlashscreenIntoState();
}

class _FlashscreenIntoState extends State<FlashscreenInto> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/flashAnimation.mp4")
      ..initialize().then((_) {
        setState(() {});
        Timer(const Duration(seconds: 4), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });
      })
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
