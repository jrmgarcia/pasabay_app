import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String uid;
  String displayName;
  String email;
  String photoUrl;

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;    

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoUrl != null);

      displayName = user.displayName;
      email = user.email;
      photoUrl = user.photoUrl;

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      uid = currentUser.uid;

      print("User signed in.");  

      return user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signOutGoogle() async {
    try {
      await googleSignIn.signOut();
      print("User signed out.");
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    return user != null;
  }
}