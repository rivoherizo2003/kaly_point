import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kaly_point/constants/colors.dart';
import 'package:kaly_point/viewmodels/checkpoint_viewmodel.dart';
import 'package:kaly_point/viewmodels/perform_check_point_viewmodel.dart';
import 'package:kaly_point/views/sessions/session_page.dart';
import 'package:kaly_point/viewmodels/session_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI
    sqfliteFfiInit();
     
    // Change the default factory to FFI for Desktop
    databaseFactory = databaseFactoryFfi;
  }
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
        ChangeNotifierProvider(create: (_) => CheckpointViewmodel()),
        ChangeNotifierProvider(create: (_) => PerformCheckPointPageViewModel()),
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

