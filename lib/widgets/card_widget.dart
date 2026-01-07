import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.cardTitle,
    required this.enabledEdit,
    required this.enabledDelete,
    this.cardText1,
    this.cardText2,
  });

  final String cardTitle;
  final String? cardText1;
  final String? cardText2;
  final bool enabledEdit;
  final bool enabledDelete;

  @override
  Widget build(BuildContext build) {
    final VoidCallback? onPressedEdit = enabledEdit ? () {} : null;
    final VoidCallback? onPressedDelete = enabledDelete ? () {} : null;

    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: 300,
        height: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        cardText1 ?? "",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        cardText2 ?? "",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 4.0,
              children: <Widget>[
                IconButton.outlined(
                  onPressed: onPressedEdit,
                  icon: const Icon(Icons.edit),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 1),
                    foregroundColor: Colors.blue,
                  ),
                ),
                IconButton.outlined(
                  onPressed: onPressedDelete,
                  icon: const Icon(Icons.delete),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1),
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
