import 'dart:convert';
import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

const String appId = '24d38bab68d94c138cc5ef08ea07d357';

class CallController {
  late Function refresh;
  late String userId;

  late RtcEngine engine;
  String? roomId;

  bool isSpeakerOn = true;
  bool isAudioOn = true;
  bool isVideoOn = true;
  bool isFrontCameraSelected = true;

  int? remoteUid;
  bool localUserJoined = false;

  void init(
    Function refresh, {
    String? roomId,
  }) {
    this.refresh = refresh;
    this.roomId = roomId;
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    if (roomId == null) {
      await createRoom();
    }

    engine = createAgoraRtcEngine();
    FlutterLogs.logInfo('Call', 'initAgora', 'Create Agora Rtc Engine');
    await engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    FlutterLogs.logInfo('Call', 'initAgora', 'Engine initialized');

    agoraEventHandlers();

    String? token = await fetchAgoraToken(roomId!, 0);

    FlutterLogs.logInfo('Call', 'fetchAgoraToken', token ?? '');

    if (token == null) {
      return;
    }

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    FlutterLogs.logInfo('Call', 'initAgora', 'started Preview');

    await engine.joinChannel(
      token: token,
      channelId: roomId!,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    FlutterLogs.logInfo('Call', 'channel joined ', roomId ?? '');
  }

  void agoraEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          FlutterLogs.logInfo(
              'Call: agoraEventHandlers',
              'onJoinChannelSuccess',
              'local user ${connection.localUid} joined');

          debugPrint('local user ${connection.localUid} joined');
          localUserJoined = true;
          refresh();
        },
        onUserJoined: (RtcConnection connection, int? remoteUid, int elapsed) {
          FlutterLogs.logInfo('Call: agoraEventHandlers', 'onUserJoined',
              'remote user $remoteUid joined');
          debugPrint('remote user $remoteUid joined');
          this.remoteUid = remoteUid;
          refresh();
        },
        onUserOffline: (RtcConnection connection, int? remoteUid,
            UserOfflineReasonType reason) {
          FlutterLogs.logInfo('Call: agoraEventHandlers', 'onUserOffline',
              'remote user $remoteUid left channel');
          debugPrint('remote user $remoteUid left channel');

          remoteUid = null;
          refresh();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          FlutterLogs.logInfo(
              'Call: agoraEventHandlers',
              'onTokenPrivilegeWillExpire',
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
  }

  Future<void> dispose() async {
    await engine.leaveChannel();
    await engine.release();
  }

  int generarNumeroRandom() {
    Random random = Random();
    return random.nextInt(9000) + 1000;
  }

  Future<void> createRoom() async {
    int id = generarNumeroRandom();
    roomId = id.toString();
    refresh();
  }

  Future<String?> fetchAgoraToken(String channelName, int uid) async {
    try {
      var response = await http.get(
        Uri.parse(
          'https://us-central1-synagein-60e00.cloudfunctions.net/app/generateToken/$uid/$channelName',
        ),
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return body['data']['token'];
      }
    } catch (e) {
      print('Error fetching token: $e');
    }
    return null;
  }

  Future<void> toggleMic() async {
    isAudioOn = !isAudioOn;
    if (isAudioOn) {
      await engine.muteLocalAudioStream(false);
    } else {
      await engine.muteLocalAudioStream(true);
    }
    refresh();
  }

  Future<void> toggleCamera() async {
    isVideoOn = !isVideoOn;
    if (isVideoOn) {
      await engine.enableVideo();
    } else {
      await engine.disableVideo();
    }
    refresh();
  }

  Future<void> toggleSpeaker() async {
    isSpeakerOn = !isSpeakerOn;
    if (isSpeakerOn) {
      await engine.setEnableSpeakerphone(false);
    } else {
      await engine.setEnableSpeakerphone(true);
    }
    refresh();
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    refresh();
  }

  Future<void> endCall() async {
    await engine.leaveChannel();
  }
}
