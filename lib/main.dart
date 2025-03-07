import 'package:employee_record/config/dependencies.dart';
import 'package:employee_record/presentation/core/themes/app_colors.dart' show AppColors;
import 'package:employee_record/presentation/pages/employee_page.dart';
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
     scaffoldBackgroundColor: Colors.white,
         inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
           
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            
            borderSide: const BorderSide(color: Colors.blue, width: 2), // Global Focused Border Color
          ),
        ),
        appBarTheme: AppBarTheme(
      backgroundColor: HexColor(AppColors.blue), 
      elevation: 0, 
      // iconTheme: IconThemeData(color: Colors.white), // Optional: Icon color
       titleTextStyle: TextStyle(color: Colors.white, fontSize: 18), // Text color
    ),
      ),
     
      home:  EmployeeScreen()
      
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Text("ssss"));
  }
}

