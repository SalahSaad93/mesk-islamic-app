import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/clay_animation_util.dart';

class BackgroundBlob {
  final Color color;
  final double size;
  final double opacity;
  final Alignment position;
  final Duration animationDuration;
  final double driftRange;

  const BackgroundBlob({
    required this.color,
    this.size = 200,
    this.opacity = 0.15,
    required this.position,
    this.animationDuration = const Duration(seconds: 8),
    this.driftRange = 30,
  });
}

class BackgroundBlobsLayer extends StatefulWidget {
  final List<BackgroundBlob> blobs;
  final bool respectReducedMotion;

  const BackgroundBlobsLayer({
    super.key,
    required this.blobs,
    this.respectReducedMotion = true,
  });

  @override
  State<BackgroundBlobsLayer> createState() => _BackgroundBlobsLayerState();
}

class _BackgroundBlobsLayerState extends State<BackgroundBlobsLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _driftController;
  final Map<int, Offset> _blobOffsets = {};

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: ClayAnimationUtil.blobDrift,
    )..repeat(reverse: true);

    _driftController.addListener(() {
      setState(() {
        for (var i = 0; i < widget.blobs.length; i++) {
          final blob = widget.blobs[i];
          final progress = _driftController.value;
          final yOffset =
              math.sin(progress * math.pi * 2 + i) * blob.driftRange;
          final xOffset =
              math.cos(progress * math.pi * 2 + i * 0.5) *
              (blob.driftRange * 0.5);
          _blobOffsets[i] = Offset(xOffset, yOffset);
        }
      });
    });
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldAnimate = widget.respectReducedMotion
        ? ClayAnimationUtil.shouldAnimate(context)
        : true;

    return RepaintBoundary(
      child: Stack(
        children: widget.blobs.asMap().entries.map((entry) {
          final index = entry.key;
          final blob = entry.value;
          final offset = _blobOffsets[index] ?? Offset.zero;

          return AnimatedBuilder(
            animation: shouldAnimate
                ? _driftController
                : AlwaysStoppedAnimation(0),
            builder: (context, child) {
              final animatedOffset = shouldAnimate ? offset : Offset.zero;
              final position = Alignment(
                blob.position.x + animatedOffset.dx / 500,
                blob.position.y + animatedOffset.dy / 500,
              );

              return Positioned.fill(
                child: Align(
                  alignment: position,
                  child: Opacity(
                    opacity: blob.opacity,
                    child: Container(
                      width: blob.size,
                      height: blob.size,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, 0),
                          radius: blob.size / 2,
                          colors: [
                            blob.color.withValues(alpha: blob.opacity),
                            blob.color.withValues(alpha: 0),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
