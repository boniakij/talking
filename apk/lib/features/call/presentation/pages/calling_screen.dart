import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:banitalk/core/theme/app_theme.dart';
import '../bloc/call_bloc.dart';
import '../bloc/call_event.dart';
import '../bloc/call_state.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CallBloc, CallState>(
        listener: (context, state) {
          if (state is CallEndedState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is CallRinging) {
            return _buildRingingUI(context, state);
          }
          if (state is CallConnected) {
            return _buildConnectedUI(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildRingingUI(BuildContext context, CallRinging state) {
    final session = state.session;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background blur
        if (session.calleeAvatar != null)
          Image.network(session.calleeAvatar!, fit: BoxFit.cover)
        else
          Container(color: BaniTalkTheme.surface2),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Animated pulsating avatar
            _PulsatingAvatar(avatar: session.calleeAvatar),
            const SizedBox(height: 24),
            Text(
              session.calleeName,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              state.isOutgoing ? 'Calling...' : 'Incoming Call',
              style: TextStyle(color: BaniTalkTheme.textSecondary, fontSize: 18),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallActionBtn(
                    icon: Icons.call_end_rounded,
                    color: Colors.red,
                    onTap: () => context.read<CallBloc>().add(EndCallEvent(session.id)),
                  ),
                  if (!state.isOutgoing)
                    _CallActionBtn(
                      icon: Icons.call_rounded,
                      color: Colors.green,
                      onTap: () => context.read<CallBloc>().add(AnswerCall(session.id)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConnectedUI(BuildContext context, CallConnected state) {
    return Stack(
      children: [
        // Remote Video
        RTCVideoView(state.remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
        
        // Local Video (floating)
        Positioned(
          top: 64,
          right: 16,
          child: Container(
            width: 120,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: RTCVideoView(state.localRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
            ),
          ),
        ),
        
        // Controls
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ControlIcon(icon: Icons.videocam),
                const SizedBox(width: 24),
                _ControlIcon(icon: Icons.mic),
                const SizedBox(width: 24),
                _CallActionBtn(
                  icon: Icons.call_end_rounded,
                  color: Colors.red,
                  onTap: () => context.read<CallBloc>().add(EndCallEvent(state.session.id)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PulsatingAvatar extends StatelessWidget {
  final String? avatar;
  const _PulsatingAvatar({this.avatar});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundColor: BaniTalkTheme.primary.withOpacity(0.2),
      child: CircleAvatar(
        radius: 70,
        backgroundColor: BaniTalkTheme.surface2,
        backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
      ),
    );
  }
}

class _CallActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CallActionBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}

class _ControlIcon extends StatelessWidget {
  final IconData icon;
  const _ControlIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: Colors.white, size: 28);
  }
}
