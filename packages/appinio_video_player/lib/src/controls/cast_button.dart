import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class CastButton extends StatefulWidget {
  final CustomVideoPlayerController customVideoPlayerController;

  const CastButton({Key? key, required this.customVideoPlayerController}) : super(key: key);

  @override
  State<CastButton> createState() => _CastButtonState();
}

class _CastButtonState extends State<CastButton> {
  bool _areControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _areControlsVisible = widget.customVideoPlayerController.areControlsVisible.value;
    widget.customVideoPlayerController.areControlsVisible.addListener(() {
      if (!mounted) return;
      setState(() {
        _areControlsVisible = widget.customVideoPlayerController.areControlsVisible.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      child: Container(
        margin: widget.customVideoPlayerController.customVideoPlayerSettings.controlsPadding,
        child: _areControlsVisible
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: widget.customVideoPlayerController.customVideoPlayerSettings.castButton,
              )
            : null,
      ),
    );
  }
}
