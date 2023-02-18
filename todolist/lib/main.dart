import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: buildAppBar(context),
        body: Column(
          children: [
            SizedBox(
              height: height / 20,
            ),
            buildbody(context),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('todo').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 30, vertical: height / 30),
                        child: ListView(
                          children: snapshot.data!.docs.map((document) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width / 25,
                                      vertical: height / 70),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width / 2),
                                  ),
                                  width: width,
                                  child: ListTile(
                                    leading: Icon(Icons.arrow_forward),
                                    title: Text(
                                      document['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          onDelete(document.id);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                })
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.purple,
      leading: Icon(Icons.menu, color: Colors.black),
      actions: [
        Padding(
          padding: EdgeInsets.all(width / 50),
          child: Image.asset(
            'assets/avatar.png',
            width: width / 10,
            height: height / 10,
          ),
        )
      ],
    );
  }

  Widget buildbody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
            child: Container(
                width: width,
                height: height / 15,
                margin: EdgeInsets.only(left: width / 20, right: width / 20),
                padding: EdgeInsets.only(left: width / 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width / 5),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ))),
        TextButton(
            onPressed: () {
              addTask();
            },
            child: Text(
              'add task',
              style: TextStyle(
                color: Colors.black,
              ),
            ))
      ],
    );
  }

  void addTask() {
    FirebaseFirestore.instance
        .collection('todo')
        .add({'title': _controller.text});
  }

  onDelete(String id) {
    FirebaseFirestore.instance.collection('todo').doc(id).delete();
  }
}
