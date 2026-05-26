import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final String? warningText;

  const ConfirmDialog({
    super.key,
    this.title = 'Confirm delete',
    this.content =
        'Are you sure you want to proceed? This action cannot be undone.',
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.warningText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content),
          if(warningText != null)...[
            const SizedBox(height: 12,),
            Text(
              warningText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          ]
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
