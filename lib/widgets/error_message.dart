import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final dynamic errorMessage;
  final dynamic callBackDismiss;

  const ErrorMessage({
    super.key,
    required this.errorMessage,
    required this.callBackDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: callBackDismiss,
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
