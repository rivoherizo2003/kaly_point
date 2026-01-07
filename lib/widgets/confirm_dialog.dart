import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  const ConfirmDialog({
    super.key,
    this.title = 'Confirm delete',
    this.content =
        'Are you sure you want to proceed? This action cannot be undone.',
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(cancelText)),
        TextButton(onPressed: () => Navigator.of(context).pop(true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: Text(confirmText),)
      ],
    );
  }
}
