import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.cardTitle,
    required this.enabledEdit,
    required this.enabledDelete,
    required this.callBackButton1,
    required this.callBackButton2,
    this.cardText1,
    this.cardText2,
  });

  final String cardTitle;
  final String? cardText1;
  final String? cardText2;
  final bool enabledEdit;
  final bool enabledDelete;
  final VoidCallback callBackButton1;
  final VoidCallback callBackButton2;



  @override
  Widget build(BuildContext build) {

    return Padding(
      padding: EdgeInsets.all(10),
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
                  onPressed: callBackButton1,
                  icon: const Icon(Icons.edit),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Colors.blue, width: 1),
                    foregroundColor: Colors.blue,
                  ),
                ),
                IconButton.outlined(
                  onPressed: callBackButton2,
                  icon: const Icon(Icons.delete),
                  style: IconButton.styleFrom(
                    side: const BorderSide(color: Color.fromARGB(255, 178, 7, 118), width: 1),
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
