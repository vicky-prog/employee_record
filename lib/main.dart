import 'package:employee_record/config/dependencies.dart';
import 'package:employee_record/presentation/core/themes/app_colors.dart' show AppColors;
import 'package:employee_record/presentation/pages/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';


void main() {
  runApp(MultiBlocProvider(providers: getBlocProviders(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
      backgroundColor: HexColor(AppColors.blue), 
      elevation: 0, 
      // iconTheme: IconThemeData(color: Colors.white), // Optional: Icon color
      // titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), // Text color
    ),
      ),
      home:  EmployeeScreen()
      
    );
  }
}

