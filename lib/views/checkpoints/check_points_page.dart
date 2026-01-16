import 'package:flutter/material.dart';

class CheckPointsPage extends StatefulWidget {
  const CheckPointsPage({super.key, required int sessionId});

  @override
  State<CheckPointsPage> createState() => _CheckPointsPageState();
}

class _CheckPointsPageState extends State<CheckPointsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}