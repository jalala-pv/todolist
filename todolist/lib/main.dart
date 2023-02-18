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
        backgroundColor:Colors.grey[900],
        appBar: buildAppBar(),
        body: Column(
          children: [
            // SearchBox(context),
            SizedBox(
              height: 30,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: ListView(
                          children: snapshot.data!.docs.map((document) {
                            return Column(
                              children: [
                                
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                                  decoration: BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),),
                                  width: width,
                                  child: ListTile(
                                    leading: Icon(Icons.arrow_forward),
                                    
                                    title: Text(document['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                                    trailing: IconButton(onPressed: (){}, icon:Icon(Icons.delete,color: Colors.red,)),
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

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.yellow[200],
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

  Widget SearchBox(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height / 15,
      margin: EdgeInsets.only(
        left: width / 20,
        right: width / 20,
      ),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white,
      ),
      child: TextField(
        decoration: InputDecoration(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            border: InputBorder.none,
            hintText: 'Search'),
      ),
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
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
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
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  void addTask() {
    FirebaseFirestore.instance
        .collection('todo')
        .add({'title': _controller.text});
  }
}
