import 'package:flutter/material.dart';

class TabListServedPersons extends StatelessWidget {
const TabListServedPersons({ super.key });

  @override
  Widget build(BuildContext context){
    return ListView.builder(itemBuilder: (context, index){
      return Text("list served");
    });
  }
}