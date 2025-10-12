import 'dart:async';
import 'package:flutter/material.dart';

class LoadingTextIndicator extends StatefulWidget {
  final String baseText;
  final TextStyle? style;
  final Duration interval;

  const LoadingTextIndicator({
    super.key,
    this.baseText = 'Ouvindo',
    this.style,
    this.interval = const Duration(milliseconds: 300),
  });

  @override
  State<LoadingTextIndicator> createState() => _LoadingTextIndicatorState();
}

class _LoadingTextIndicatorState extends State<LoadingTextIndicator> {
  late Timer _timer;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (_) {
      setState(() => _dotCount = (_dotCount + 1) % 4);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.baseText}${'.' * _dotCount}',
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}
