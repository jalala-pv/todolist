import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: buildAppBar(),
        body: Column(
          children: [
            Container(width: width,height: height/15,margin: EdgeInsets.only(left:width/10,right: width/10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              
            ),child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(padding:EdgeInsets.only(left: 5,right: 5),child: Icon(Icons.search)),
                Text('Search')
              ],
            ),)
          ],
        ));
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[300],
      leading: Icon(Icons.menu, color: Colors.black),
      actions: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            'assets/avatar.png',
            width: 40,
            height: 40,
          ),
        )
      ],
    );
  }
}
