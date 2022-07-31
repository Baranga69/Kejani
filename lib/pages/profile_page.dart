import 'package:another_nav_bar/pages/login_page.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_nav_bar/utilities/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final _uid = user!.uid;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: COLOR_DARK_BLUE,
          child: const Icon(Icons.logout, color: Colors.white,), 
          onPressed: () async{
          await _auth.signOut();
          goToPage(context);
        },
        ),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.connectionState != ConnectionState.active){
              return Center(child: Loading(),
              );
            } 
            CollectionReference users = FirebaseFirestore.instance.collection('Kejani Users');
            return FutureBuilder<DocumentSnapshot>(
            future: users.doc(_uid).get(),
              builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if (snapshot.hasError){
                  return Center(child: Text("Something went wrong"),);
                }
                if (snapshot.hasData && !snapshot.data!.exists){
                  return Center(child: Text("Document does not exist"),);
                }
                if (snapshot.connectionState == ConnectionState.done){
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 3,
                      shadowColor: COLOR_DARK_BLUE,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                radius: 70.0,
                                backgroundImage: NetworkImage("${data['ImgUrl']}"),
                              ),
                            ),
                            Divider(
                              color: COLOR_BLACK,
                              height: 60.0,
                            ),
                            Text('USERNAME',
                              style: TextStyle(
                                color: COLOR_GREY,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text("${data['Username']}",
                              style: TextStyle(
                                color: COLOR_DARK_BLUE,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'CURRENT TOWN',
                              style: TextStyle(
                                color: COLOR_GREY,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text("${data['Residence']}",
                              style: TextStyle(
                                color:  COLOR_DARK_BLUE,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'PHONE NUMBER',
                              style: TextStyle(
                                color: COLOR_GREY,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text("${data['PhoneNumber']}",
                              style: TextStyle(
                                color:  COLOR_DARK_BLUE,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                                  'EMAIL ADDRESS',
                                  style: TextStyle(
                                    color: COLOR_GREY,
                                    letterSpacing: 2.0,
                                  ),
                            ),
                            SizedBox(height: 20.0),   
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  color: COLOR_BLACK,
                                ),
                                SizedBox(width: 10.0),
                                Text("${data['Email']}",
                                  style: TextStyle(
                                    color: COLOR_DARK_BLUE,
                                    fontSize: 18.0,
                                    letterSpacing: 1.0,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 30.0),
                            Text(
                                  'USER TYPE',
                                  style: TextStyle(
                                    color: COLOR_GREY,
                                    letterSpacing: 2.0,
                                  ),
                            ),
                            SizedBox(height: 20.0),   
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  color: COLOR_BLACK,
                                ),
                                SizedBox(width: 10.0),
                                Text("${data['UserType']}",
                                  style: TextStyle(
                                    color: COLOR_DARK_BLUE,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                    letterSpacing: 2.0,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                } else {
                  return Center(child: Loading());
                }
              },
            );
          },
        )
      ),
    );
  }
}
void goToPage(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));