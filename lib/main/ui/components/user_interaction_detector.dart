import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/main/mixins/frame_binding.dart';
import 'package:rxdart/rxdart.dart';

class _UserInteractionDetectorContainer extends InheritedWidget {
  const _UserInteractionDetectorContainer({
    required this.userInteractionDetectorState,
    required super.child,
  });

  final UserInteractionDetectorState userInteractionDetectorState;

  @override
  bool updateShouldNotify(_UserInteractionDetectorContainer old) => true;
}

class UserInteractionDetector extends StatefulWidget {
  const UserInteractionDetector({
    required this.child,
    super.key,
  });

  static UserInteractionDetectorState? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_UserInteractionDetectorContainer>()
      ?.userInteractionDetectorState;

  @override
  UserInteractionDetectorState createState() => UserInteractionDetectorState();

  final Widget child;
}

class UserInteractionDetectorState extends State<UserInteractionDetector>
    with FrameBinding {
  UserInteractionDetectorState() {
    _noInteractionTimer = _onUserInteracting.startWith(null).switchMap(
          (event) => Stream.periodic(
                  const Duration(minutes: 1), (iteration) => iteration)
              .map((event) => event + 1),
        );
  }

  final Subject<void> _onUserInteracting = PublishSubject();

  late Stream<int> _noInteractionTimer;

  Stream<void> get onUserInteracting => _onUserInteracting;

  Stream<int> get noInteractionTimer => _noInteractionTimer;

  void postponeEvents() {
    _sendInteractionEvent();
  }

  @override
  void didRenderFrame(BuildContext context) => _sendInteractionEvent();

  @override
  Widget build(BuildContext context) {
    return _UserInteractionDetectorContainer(
      userInteractionDetectorState: this,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanDown: (_) => _sendInteractionEvent(),
        child: widget.child,
      ),
    );
  }

  void _sendInteractionEvent() {
    if (!_onUserInteracting.isClosed) {
      _onUserInteracting.add(null);
    }
  }

  @override
  void dispose() {
    _onUserInteracting.close();
    super.dispose();
  }
}
