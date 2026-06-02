import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';

class ListTilePerson extends StatelessWidget {
  final PersonCheckPointDto personCheckPointDto;
  final VoidCallback callBackTilePerson;
  final VoidCallback callBackEndToStart;
  final VoidCallback callBackStartToEnd;
  final Color iconColor;
  final Color colorBtnAndForegroundBtn;
  final Icon icon;
  final Color borderBtnColor;
  final bool ignoringPointer;

  const ListTilePerson({
    super.key,
    required this.callBackTilePerson,
    required this.personCheckPointDto,
    required this.iconColor,
    required this.icon,
    required this.colorBtnAndForegroundBtn,
    required this.borderBtnColor,
    required this.callBackEndToStart,
    required this.callBackStartToEnd,
    required this.ignoringPointer,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(personCheckPointDto.personId),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.blue.shade200,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red.shade200,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          callBackEndToStart();

          return false;
        } else if (direction == DismissDirection.startToEnd) {
          callBackStartToEnd();

          return false;
        }

        return true;
      },
      onDismissed: (direction) {},
      child: ListTile(
        enabled: true,
        selected: false,
        textColor: Colors.black,
        leading: Icon(Icons.person, color: iconColor),
        title: Text(
          "${personCheckPointDto.lastname} N°: ${personCheckPointDto.personId}",
        ),
        subtitle: Text(personCheckPointDto.firstname!),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IgnorePointer(
              ignoring: ignoringPointer,
              child: IconButton.outlined(
                onPressed: callBackTilePerson,
                icon: icon,
                style: IconButton.styleFrom(
                  side: BorderSide(color: borderBtnColor, width: 1),
                  foregroundColor: colorBtnAndForegroundBtn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
