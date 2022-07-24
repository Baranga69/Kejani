import 'package:another_nav_bar/pages/home_screen.dart';
import 'package:another_nav_bar/pages/sign_up_page.dart';
import 'package:another_nav_bar/services/auth.dart';
import 'package:another_nav_bar/utilities/constants.dart';
import 'package:another_nav_bar/utilities/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        ),
        backgroundColor: COLOR_WHITE,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            'Log in to Kejani to continue',
                            textAlign: TextAlign.center,
                            style:
                                GoogleFonts.openSans(color: COLOR_BLACK, fontSize: 28),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Enter your email and password below to begin the search for your new home',
                            textAlign: TextAlign.center,
                            style:
                                GoogleFonts.openSans(color: COLOR_BLACK, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                     Card(
                      elevation: 7,
                      margin: EdgeInsets.all(5),
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Column(
                           children: [
                             Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                              color: COLOR_WHITE, 
                              border: Border.all(color: COLOR_DARK_BLUE),
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                              child: TextFormField(
                                validator: (val) => val!.isEmpty? 'Enter an email':null,
                                style: TextStyle(color: COLOR_BLACK),
                                decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                labelText: "Email",
                                labelStyle: TextStyle(color: COLOR_BLACK),
                                icon: Icon(Icons.email, color: COLOR_BLACK),
                                border: InputBorder.none),
                                  onChanged: (val){
                                    setState(() => email = val);
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                             Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                              color: COLOR_WHITE, 
                              border: Border.all(color: COLOR_DARK_BLUE),
                              borderRadius: BorderRadius.all(Radius.circular(15))),
                              child: TextFormField(
                                  validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long':null,
                                  style: TextStyle(color: COLOR_BLACK),
                                  decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  labelText: "Password",
                                  labelStyle: TextStyle(color: COLOR_BLACK),
                                  icon: Icon(Icons.lock, color: COLOR_BLACK),
                                  border: InputBorder.none),
                                  obscureText: true,
                                  onChanged: (val){
                                    setState(() => password = val);
                                  },
                                ),
                               ),
                              SizedBox(height: 30),
                              MaterialButton(
                                elevation: 0,
                                minWidth: double.maxFinite,
                                height: 50,
                                onPressed: () async{
                                  if(_formKey.currentState!.validate()){
                                    setState(() => loading=true);
                                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                    if(result ==null){
                                      setState(() {
                                        error = "Could not Log in with those credentials";
                                        loading = false;
                                      });
                                    } else{
                                      goToHome(context);
                                    }
                                  }
                                },
                                color: Colors.green,
                                child: Text('Log-in',
                                    style: TextStyle(color: Colors.white, fontSize: 16)),
                                textColor: Colors.white,
                              ),
                              SizedBox(height: 20),
                              TextButton(onPressed: () => goToPage(context), child: Text('Not registered? Sign Up here',
                                style: TextStyle(color:COLOR_BLACK, fontSize: 16),)),
                              SizedBox(height: 20),
                              Text(error,
                              style: TextStyle(color: Colors.red, fontSize: 14.0),),
                           ],
                         ),
                       ),
                     ),
                    ],
                  ),
                ),
              ),
            ),
        ),
        );
  }

  void goToPage(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignUpPage()));

  void goToHome(context) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
}
