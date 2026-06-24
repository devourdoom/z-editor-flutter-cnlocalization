import 'package:flutter/material.dart';

/// Allows a pushed route (e.g. JsonViewerScreen in edit mode) or modal to handle
/// Escape before the global handler pops. When set, the global handler calls
/// this first; if it returns true, the pop is skipped.
class EscapeOverride {
  EscapeOverride._();

  static final List<bool Function()> _stack = [];

  static void push(bool Function() handler) => _stack.add(handler);
  static void pop(bool Function() handler) => _stack.remove(handler);

  /// The topmost registered handler, or null if none.
  static bool Function()? get tryHandle => _stack.isEmpty ? null : _stack.last;
}

/// Wraps modal bottom sheet content so Escape closes only the modal, not the
/// screen below. Place as the root child of the modal's builder.
class EscapeClosesModal extends StatefulWidget {
  const EscapeClosesModal({super.key, required this.child});

  final Widget child;

  @override
  State<EscapeClosesModal> createState() => _EscapeClosesModalState();
}

class _EscapeClosesModalState extends State<EscapeClosesModal> {
  late final bool Function() _handler;

  @override
  void initState() {
    super.initState();
    _handler = () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        return true;
      }
      return false;
    };
    EscapeOverride.push(_handler);
  }

  @override
  void dispose() {
    EscapeOverride.pop(_handler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
