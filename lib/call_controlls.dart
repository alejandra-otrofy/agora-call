import 'package:agora_call/call_controller.dart';
import 'package:flutter/material.dart';

Widget muteButton(CallController controller, double size) => Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[70],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              size: size * 0.6,
              controller.isAudioOn ? Icons.mic : Icons.mic_off,
              color: Colors.white,
            ),
            onPressed: controller.toggleMic,
          ),
        ),
        Text(
          controller.isAudioOn ? 'Mute' : 'Unmute',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );

Widget cameraButton(CallController controller, double size) => Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[70],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              size: size * 0.6,
              controller.isVideoOn ? Icons.videocam : Icons.videocam_off,
              color: Colors.white,
            ),
            onPressed: controller.toggleCamera,
          ),
        ),
        Text(
          controller.isVideoOn ? 'Camera Off' : 'Camera On',
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );

Widget speakerButton(CallController controller, double size) => Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: !controller.isSpeakerOn ? Colors.white : Colors.grey[70],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              size: size * 0.6,
              Icons.volume_up,
              color: controller.isSpeakerOn ? Colors.white : Colors.black,
            ),
            onPressed: controller.toggleSpeaker,
          ),
        ),
        const Text(
          'Speaker',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );

Widget flipButton(CallController controller, double size) => Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey[70],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.flip_camera_ios,
              color: Colors.white,
              size: size * 0.6,
            ),
            onPressed: controller.switchCamera,
          ),
        ),
        const Text(
          'Flip',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );

Widget hangUpButton(CallController controller, double size) => Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              size: size * 0.6,
              Icons.close,
              color: Colors.white,
            ),
            onPressed: controller.endCall,
          ),
        ),
        const Text(
          'End',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
