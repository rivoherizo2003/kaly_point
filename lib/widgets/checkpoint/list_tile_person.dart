import 'package:flutter/material.dart';
import 'package:kaly_point/dto/person_check_point_dto.dart';

class ListTilePerson extends StatelessWidget {
  final PersonCheckPointDto personCheckPointDto;
  final VoidCallback callBackTilePerson;
  final Color iconColor;
  final Color colorBtnAndForegroundBtn;
  final Icon icon;

  const ListTilePerson({
    super.key,
    required this.callBackTilePerson,
    required this.personCheckPointDto,
    required this.iconColor,
    required this.icon,
    required this.colorBtnAndForegroundBtn,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: true,
      selected: false,
      iconColor: iconColor,
      textColor: Colors.black,
      leading: const Icon(Icons.person),
      title: Text("${personCheckPointDto.lastname} N°: ${personCheckPointDto.personId}"),
      subtitle: Text(personCheckPointDto.firstname!),
      trailing: IconButton.outlined(
        onPressed: callBackTilePerson,
        icon: icon,
        style: IconButton.styleFrom(
          side: BorderSide(color: colorBtnAndForegroundBtn, width: 1),
          foregroundColor: colorBtnAndForegroundBtn,
        ),
      ),
    );
  }
}
