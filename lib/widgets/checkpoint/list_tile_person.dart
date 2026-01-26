import 'package:flutter/material.dart';

class ListTilePerson extends StatelessWidget {
  final String? firstname;
  final String lastname;
  final VoidCallback callBackTilePerson;
  final int personId;
  final Widget icon;
  final Color colorBtn;
  final Color foregroundColorBtn;
  


  const ListTilePerson({super.key, required this.lastname, this.firstname, required this.callBackTilePerson, required this.personId, required this.icon, required this.colorBtn, required this.foregroundColorBtn});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: true,
      selected: false,
      iconColor: Colors.blue,
      textColor: Colors.black,
      leading: const Icon(Icons.person),
      title: Text("$lastname N°: $personId"),
      subtitle: Text(firstname!),
      trailing: IconButton.outlined(
                  onPressed: callBackTilePerson,
                  icon: icon, //const Icon(Icons.check),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: colorBtn, width: 1),
                    foregroundColor: foregroundColorBtn,
                  ),
                ),
    );
  }
}
