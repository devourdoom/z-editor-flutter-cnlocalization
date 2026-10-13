import 'package:flutter/material.dart';

/// Keeps the thumb of every vertical app scrollbar visible on every platform.
///
/// Flutter only inserts automatic scrollbars on desktop by default. C-Editor
/// uses the same persistent visual cue on mobile and web so a clipped page does
/// not look as though it ends at the bottom of the viewport. Horizontal
/// controls keep their existing, component-specific scrollbar behavior.
class PersistentScrollbarScrollBehavior extends MaterialScrollBehavior {
  const PersistentScrollbarScrollBehavior();

  bool _hasExplicitScrollbarForThisScrollable(BuildContext context) {
    var found = false;
    context.visitAncestorElements((element) {
      final widget = element.widget;

      // An explicit scrollbar outside another Scrollable belongs to that outer
      // scrollable, not to this nested one. Stop there so each independently
      // scrolling vertical region can still receive its own thumb.
      if (widget is Scrollable) return false;

      if (widget is Scrollbar || widget is RawScrollbar) {
        found = true;
        return false;
      }
      return true;
    });
    return found;
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (axisDirectionToAxis(details.direction) == Axis.horizontal ||
        details.controller == null ||
        _hasExplicitScrollbarForThisScrollable(context)) {
      return child;
    }

    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      scrollbarOrientation: ScrollbarOrientation.right,
      child: child,
    );
  }
}
