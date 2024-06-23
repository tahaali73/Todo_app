import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../database_service/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool Home = true, School = false, Tuition = false;
  bool suggest = false;
  TextEditingController todocontroller = TextEditingController();
  Stream? todoStream;

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  getontheload() async {
    todoStream = await DataBaseService().getTask(Home ? "Home" : School ? "School" : "Tuition");
    setState(() {});
  }

  Widget getWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(child: Text('No tasks available.'));
        }
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot docSnap = snapshot.data.docs[index];
              return CheckboxListTile(
                activeColor: Colors.black,
                title: Text(docSnap["work"]),
                value: docSnap["yes"],
                onChanged: (newValue) async{

                    await DataBaseService().deleteTask(docSnap["id"],
                        Home ? "Home" : School ? "School" : "Tuition");
                    setState(() {
                      Future.delayed(Duration(seconds: 2),(){
                        DataBaseService().removeTask(docSnap["id"],
                            Home ? "Home" : School ? "School" : "Tuition");
                      });
                    });
                 // });
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
        );
      },
    );
  }

  Future dialogbox() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.cancel, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Add Tasks',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                  ),
                  child: TextField(
                    controller: todocontroller,
                    decoration: InputDecoration(hintText: 'Add task here'),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> userTodo = {
                        "work": todocontroller.text,
                        "id": id,
                        "yes":false,
                      };
                      if (Home) {
                        DataBaseService().addHomeTask(userTodo, id);
                      } else if (Tuition) {
                        DataBaseService().addTutionTask(userTodo, id);
                      } else {
                        DataBaseService().addSchoolTask(userTodo, id);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'Add Task',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogbox();
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.only(top: h * 0.015, right: h * 0.04, left: h * 0.04, bottom: h * 0.015),
        child: Container(
          padding: EdgeInsets.only(top: h * 0.015, right: h * 0.04, left: h * 0.04, bottom: h * 0.015),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Colors.lightGreenAccent,
              Colors.pinkAccent,
              Colors.deepOrangeAccent,
            ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: h * 0.1,
                width: w * 0.2,
                child: Text(
                  'Hi,',
                  style: TextStyle(
                    fontSize: h * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: h * 0.1,
                width: w * 0.2,
                child: Text(
                  'Taha',
                  style: TextStyle(
                    fontSize: h * 0.06,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              Center(
                child: Container(
                  height: h * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightGreenAccent,
                  ),
                  width: w * 0.4,
                  child: Center(
                    child: Text(
                      "Let's prove yourself Today",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Home
                      ? Material(
                    elevation: 40,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'Home',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () async {
                      Home = true;
                      Tuition = false;
                      School = false;
                      await getontheload();
                      setState(() {});
                    },
                    child: Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          'Home',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  School
                      ? Material(
                    elevation: 40,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'School',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () async {
                      Home = false;
                      Tuition = false;
                      School = true;
                      await getontheload();
                      setState(() {});
                    },
                    child: Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          'School',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Tuition
                      ? Material(
                    elevation: 40,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          'Tuition',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () async {
                      Home = false;
                      Tuition = true;
                      School = false;
                      await getontheload();
                      setState(() {});
                    },
                    child: Container(
                      height: h * 0.08,
                      width: w * 0.2,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          'Tuition',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),
              getWork(),
            ],
          ),
        ),
      ),
    );
  }
}
