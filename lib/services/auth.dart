import 'package:another_nav_bar/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebase user
  TheUser? _userFromFirebaseUser(User user){
    // ignore: unnecessary_null_comparison
    return user != null? TheUser(uid:user.uid): null;
  }
  
  // auth change user stream
  Stream<TheUser?> get user{
    return _auth.authStateChanges()
      .map((User? user) => _userFromFirebaseUser(user!));
  }
  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future regWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? fireUser = result.user;
      return _userFromFirebaseUser(fireUser!);
      //creating a new document fore the user with their uid
     // await DatabaseService(uid: fireUser!.uid).updateUserData(email, username, phoneNumber, residence, imgUrl);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

}