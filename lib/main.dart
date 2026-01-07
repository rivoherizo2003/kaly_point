import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/views/sessions/session_page.dart';
import 'package:kaly_point/viewmodels/sessions/session_viewmodel.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
      ],
      child: MaterialApp(
        title: 'Kaly Point',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        ),
        home: const SessionPage(title: 'Sessions'),
      ),
    );
  }
}

