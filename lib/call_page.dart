import 'package:agora_call/call_controller.dart';
import 'package:agora_call/call_controlls.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class CallPage extends StatefulWidget {
  const CallPage({this.roomId, Key? key}) : super(key: key);
  final String? roomId;

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  CallController controller = CallController();

  @override
  void initState() {
    super.initState();
    controller.init(refresh, roomId: widget.roomId);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(controller.roomId ?? ''),
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                  child: controller.localUserJoined
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: controller.engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
            _bottomControls(50),
          ],
        ),
      );

  // Display remote user's video
  Widget _remoteVideo() {
    if (controller.remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.engine,
          canvas: VideoCanvas(uid: controller.remoteUid),
          connection: RtcConnection(channelId: controller.roomId),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _bottomControls(double buttonSize) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                speakerButton(controller, buttonSize),
                cameraButton(controller, buttonSize),
                muteButton(controller, buttonSize),
                flipButton(controller, buttonSize),
                hangUpButton(controller, buttonSize),
              ],
            ),
          ),
        ),
      );

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
