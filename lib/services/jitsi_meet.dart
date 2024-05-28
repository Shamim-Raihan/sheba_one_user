import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:http/http.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:shebaone/controllers/call_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/fcm.dart';
import 'package:shebaone/utils/global.dart';

class JitsiUtil {
  static joinMeeting({
    bool isVideoCallOptionEnable = false,
    String? roomName,
    String? subject,
    String? userDisplayName,
    String? userEmail,
  }) async {
    try {
      Map<FeatureFlag, Object> featureFlags = {
        FeatureFlag.isVideoMuteButtonEnabled: isVideoCallOptionEnable,
        FeatureFlag.isVideoShareButtonEnabled: false,
        FeatureFlag.isTileViewEnabled: false,
        FeatureFlag.isChatEnabled: false,
        FeatureFlag.isHelpButtonEnabled: false,
        FeatureFlag.isAudioOnlyButtonEnabled: true,
        FeatureFlag.isInviteEnabled: false,
        FeatureFlag.isKickoutEnabled: false,
        FeatureFlag.isAudioFocusDisabled: false,
        FeatureFlag.isLobbyModeEnabled: false,
        FeatureFlag.isOverflowMenuEnabled: false,
        FeatureFlag.isAddPeopleEnabled: false,
        FeatureFlag.isToolboxAlwaysVisible: false,
        FeatureFlag.isCloseCaptionsEnabled: false,
        FeatureFlag.isNotificationsEnabled: false,
        FeatureFlag.isFullscreenEnabled: false,
        // FeatureFlag.isFilmstripEnabled: false,
        FeatureFlag.isRaiseHandEnabled: false,
        FeatureFlag.isReplaceParticipantEnabled: false,
        FeatureFlag.isRecordingEnabled: false,
        FeatureFlag.isServerUrlChangeEnabled: false,
      };
      var options = JitsiMeetingOptions(
        roomNameOrUrl: roomName ?? 'myroom111ShebaOne',
        // serverUrl: "https://shebaone.com",
        subject: "Doctor Patient Meeting",
        userDisplayName: UserController.to.getUserInfo.name ?? 'Patient',
        userEmail: "myemail@email.com",
        isAudioMuted: false,
        isVideoMuted: !isVideoCallOptionEnable,
        featureFlags: featureFlags,
      );
      // ..roomNameOrUrl = "myroom111" // Required, spaces will be trimmed
      // ..serverUrl = "https://meet.jit.si/myroom111"
      // ..subject = "Meeting with Shubham"
      // ..userDisplayName = "My Name"
      // ..userEmail = "myemail@email.com"
      // ..isAudioOnly = true
      // ..isAudioMuted = true
      // ..isVideoMuted = true;

      await JitsiMeetWrapper.joinMeeting(
        options: options,
        listener: JitsiMeetingListener(
          onOpened: () => debugPrint("onOpened"),
          onConferenceWillJoin: (url) {
            debugPrint("onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            debugPrint("onConferenceJoined: url: $url");
          },
          onConferenceTerminated: (url, error) {
            debugPrint("onConferenceTerminated: url: $url, error: $error");
          },
          onAudioMutedChanged: (isMuted) {
            debugPrint("onAudioMutedChanged: isMuted: $isMuted");
          },
          onVideoMutedChanged: (isMuted) {
            debugPrint("onVideoMutedChanged: isMuted: $isMuted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            debugPrint(
              "onScreenShareToggled: participantId: $participantId, "
              "isSharing: $isSharing",
            );
          },
          onParticipantJoined: (email, name, role, participantId) {
            debugPrint(
              "onParticipantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
            );
          },
          onParticipantLeft: (participantId) {
            debugPrint("onParticipantLeft: participantId: $participantId");
          },
          onParticipantsInfoRetrieved: (participantsInfo, requestId) {
            debugPrint(
              "onParticipantsInfoRetrieved: participantsInfo: $participantsInfo, "
              "requestId: $requestId",
            );
          },
          onChatMessageReceived: (senderId, message, isPrivate) {
            debugPrint(
              "onChatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate",
            );
          },
          onChatToggled: (isOpen) =>
              debugPrint("onChatToggled: isOpen: $isOpen"),
          onClosed: () async {
            debugPrint("onClosed");
            if (CallController.to.callStatus.value != CallStatus.ended) {
              // await sendMessage(
              //     callStatus: 'ended',
              //     type: isVideoCallOptionEnable ? 'video' : 'audio',
              //     token: calling['extra']['token']);
              sendPushMessage(
                callStatus: 'ended',
                callType: isVideoCallOptionEnable ? 'video' : 'audio',
                token: calling['extra']['token'],
                notificationType: 'call',
                title: 'Current call',
                body: 'Call ended by user',
              );
              CallController.to.callStatus(CallStatus.ended);
              recentCallStatus = '';
              await FlutterCallkitIncoming.endCall(calling);
              await requestHttp('END_CALL');
              calling = null;
            }
          },
        ),
      ).then((value) => globalLogger.d(value, "++++++++++++++++++++++++++++"));
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static void closeMeeting() {
    JitsiMeetWrapper.hangUp();
  }
}

Future<void> requestHttp(content) async {
  get(Uri.parse(
      'https://webhook.site/2748bc41-8599-4093-b8ad-93fd328f1cd2?data=$content'));
}
