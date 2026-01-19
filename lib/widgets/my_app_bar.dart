import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
const MyAppBar({ super.key, required this.title, required this.appBarOpacity });

final String title;
final double appBarOpacity;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){
    return AppBar(
        title: Text(title),
        titleTextStyle: TextStyle(color: AppColors.primaryColor, fontSize: 20),
        backgroundColor: Colors.white.withValues(alpha: appBarOpacity),
        elevation: appBarOpacity > 0.5 ? 4.0 : 0.0,
      );
  }
} 