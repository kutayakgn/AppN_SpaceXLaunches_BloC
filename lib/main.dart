import 'package:flutter/material.dart';
import 'package:space_x_last_launch/datas/repos/launches_repository.dart';
import 'package:space_x_last_launch/screens/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Run function
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Theme of The APP
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        backgroundColor: Colors.grey[900],
      ),
      //BLOC Repository Provider
      home: RepositoryProvider(
        create: (context) => LaunchesRepository(),
        child: Home(),
      ),
    );
  }
}
