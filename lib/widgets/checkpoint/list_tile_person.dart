import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';

class ListTilePerson extends StatelessWidget {
  final PersonCheckPointDto personCheckPointDto;
  final VoidCallback callBackTilePerson;
  final Color iconColor;
  final Color colorBtnAndForegroundBtn;
  final Icon icon;
  final Color? borderBtnColor;

  const ListTilePerson({
    super.key,
    required this.callBackTilePerson,
    required this.personCheckPointDto,
    required this.iconColor,
    required this.icon,
    required this.colorBtnAndForegroundBtn,
    this.borderBtnColor,
  });


  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: true,
      selected: false,
      textColor: Colors.black,
      leading: Icon(Icons.person,color: iconColor),
      title: Text(
        "${personCheckPointDto.lastname} N°: ${personCheckPointDto.personId}",
      ),
      subtitle: Text(personCheckPointDto.firstname!),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.outlined(
            onPressed: () => {},
            icon: const Icon(Icons.delete),
            style: IconButton.styleFrom(
              side: BorderSide(
                color: Colors.red.shade200,
                width: 1,
              ),
              foregroundColor: Colors.red.shade200,
            ),
          ),
          const SizedBox(width: 3,),
          IconButton.outlined(
            onPressed: callBackTilePerson,
            icon: const Icon(Icons.edit),
            style: IconButton.styleFrom(
              side: BorderSide(
                color: Colors.blue.shade200,
                width: 1,
              ),
              foregroundColor: Colors.blue.shade200,
            ),
          ),
          const SizedBox(width: 20,),
          IconButton.outlined(
            onPressed: callBackTilePerson,
            icon: icon,
            style: IconButton.styleFrom(
              side: BorderSide(
                color: borderBtnColor == null
                    ? colorBtnAndForegroundBtn
                    : Colors.transparent,
                width: 1,
              ),
              foregroundColor: colorBtnAndForegroundBtn,
            ),
          )
        ],
      ),
    );
  }
  
}
