import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class WaveformVisualizer extends StatefulWidget {
  final bool isRecording;
  final double amplitude;
  final Color? waveColor;
  final Color? backgroundColor;

  const WaveformVisualizer({
    super.key,
    required this.isRecording,
    this.amplitude = 0.5,
    this.waveColor,
    this.backgroundColor,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    if (widget.isRecording) {
      _waveController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(WaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _waveController.repeat(reverse: true);
      } else {
        _waveController.stop();
        _waveController.reset();
      }
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: widget.isRecording
          ? AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Wave(
                  height: 120,
                  width: double.infinity,
                  config: CustomConfig(
                    colors: [
                      widget.waveColor ?? Theme.of(context).primaryColor.withOpacity(0.4),
                      widget.waveColor ?? Theme.of(context).primaryColor.withOpacity(0.6),
                      widget.waveColor ?? Theme.of(context).primaryColor,
                    ],
                    durations: [18000, 8000, 5000],
                    heightPercentages: [0.65, 0.75, widget.amplitude],
                    blur: const MaskFilter.blur(BlurStyle.solid, 3),
                    gradientBegin: Alignment.bottomLeft,
                    gradientEnd: Alignment.topRight,
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mic,
                    size: 32,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to start recording',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
