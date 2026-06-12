import 'package:flutter/material.dart';

/// Extended FAB that animates in/out (used when scroll is at top).
class AnimatedExtendedFab extends StatefulWidget {
  const AnimatedExtendedFab({
    super.key,
    required this.visible,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.heroTag,
  });

  final bool visible;
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Object? heroTag;

  @override
  State<AnimatedExtendedFab> createState() => _AnimatedExtendedFabState();
}

class _AnimatedExtendedFabState extends State<AnimatedExtendedFab>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 320);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration,
    value: widget.visible ? 1 : 0,
  );

  late final Animation<double> _reveal = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, 0.5),
    end: Offset.zero,
  ).animate(_reveal);

  @override
  void didUpdateWidget(covariant AnimatedExtendedFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _reveal,
      axisAlignment: 1,
      child: FadeTransition(
        opacity: _reveal,
        child: SlideTransition(
          position: _slide,
          child: IgnorePointer(
            ignoring: !widget.visible,
            child: FloatingActionButton.extended(
              heroTag: widget.heroTag,
              onPressed: widget.onPressed,
              icon: Icon(widget.icon),
              label: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}
