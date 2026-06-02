import 'package:flutter/material.dart';
import 'package:kaly_point/models/state_check_point.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.cardTitle,
    required this.enabledEdit,
    required this.enabledDelete,
    required this.callBackButton1,
    required this.callBackButton2,
    required this.statsPersonsCheckPoint,
    required this.stateCheckPoint,
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
  final bool statsPersonsCheckPoint;
  final StateCheckPoint stateCheckPoint;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people, color: Colors.blue.shade200),
                  const SizedBox(width: 8.0),
                  Text(
                    "${stateCheckPoint.nbrPersonInSession} prs",
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  if (statsPersonsCheckPoint) ...[
                    Icon(Icons.people, color: Colors.green),
                    const SizedBox(width: 8.0),
                    Text(
                      "${stateCheckPoint.nbrPersonServed} prs",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Icon(Icons.people, color: Colors.deepOrange),
                    const SizedBox(width: 8.0),
                    Text(
                      "${stateCheckPoint.nbrPersonToServe} prs",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (enabledEdit)
                    IconButton.outlined(
                      onPressed: callBackButton1,
                      icon: const Icon(Icons.edit),
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: Colors.blue, width: 1),
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  SizedBox(width: 8.0),
                  if (enabledDelete)
                    IconButton.outlined(
                      onPressed: callBackButton2,
                      icon: const Icon(Icons.delete),
                      style: IconButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 178, 7, 118),
                          width: 1,
                        ),
                        foregroundColor: Colors.red,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
