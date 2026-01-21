import 'package:flutter/material.dart';
import 'package:kaly_point/widgets/my_app_bar.dart';

class PerformCheckPointPage extends StatefulWidget {
  final int checkPointId;
  final int sessionId;
  final String sessionTitle;
  final String checkPointTitle;

  const PerformCheckPointPage({super.key, required this.checkPointId, required this.sessionId, required this.sessionTitle, required this.checkPointTitle});

  @override
  State<PerformCheckPointPage> createState() => _PerformCheckPointPageState();
}

class _PerformCheckPointPageState extends State<PerformCheckPointPage> {
  final double _scrollOffset = 0;
  @override
  Widget build(BuildContext context) {
    final appBarOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    return Scaffold(
      appBar: MyAppBar(title: "Pointage [${widget.checkPointTitle}]", appBarOpacity: appBarOpacity),
    );
  }
}
