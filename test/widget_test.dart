import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:kaly_point/main.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Placeholder test to ensure the application can be pumped without immediate crashes.
  // More comprehensive tests for specific functionalities should be added here.
  testWidgets('App starts and shows SessionPage title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Verify that our app starts on the SessionPage, expecting its title.
    // Replace 'Sessions' with the actual title displayed on your SessionPage.
    expect(find.text('Sessions'), findsOneWidget); 
  });
}
