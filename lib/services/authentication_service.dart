import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pasabay_app/locator.dart';
import 'package:pasabay_app/models/user.dart';
import 'package:pasabay_app/services/firestore_service.dart';

class AuthenticationService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _currentUser;
  User get currentUser => _currentUser;

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

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);

      await _populateCurrentUser(currentUser);

      // get current user rating
      var userRating;
      var ratings = await _firestoreService.getRating(user.uid);
      if (ratings.length != 0) {
        userRating = ratings.map((m) => m['rate']).reduce((a, b) => a + b) / ratings.length;
      } else userRating = 0.0;

      // get current user blacklist
      var blacklist = await _firestoreService.getBlacklist(user.uid);
      var userBlacklist = blacklist.map((b) => b['blockedUser'].toString()).toList();

      // create a new user profile on firestore
      var newUser = User(
        uid: currentUser.uid,
        displayName: currentUser.displayName,
        email: currentUser.email,
        photoUrl: currentUser.photoUrl,
        rating: userRating,
        blacklist: userBlacklist,
        chattingWith: null
      );
      _currentUser = newUser;
      
      await _firestoreService.createUser(newUser);

      print("User signed in.");

      return user != null;
    } catch (e) {}
  }

  Future signOutGoogle() async {
    try {
      await googleSignIn.signOut();
      await _firebaseAuth.signOut();
      print("User signed out.");
    } catch (e) {}
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }

  syncUserProfile(String uid) async {
    // get current user rating
    var userRating;
    var ratings = await _firestoreService.getRating(uid);
    if (ratings.length != 0) {
      userRating = ratings.map((r) => r['rate']).reduce((a, b) => a + b) / ratings.length;
    } else userRating = 0.0;

    // get current user blacklist
    var blacklist = await _firestoreService.getBlacklist(uid);
    var userBlacklist = blacklist.map((b) => b['blockedUser'].toString()).toList();

    // create a new user profile on firestore
    var userProfile = User(
      uid: currentUser.uid,
      displayName: currentUser.displayName,
      email: currentUser.email,
      photoUrl: currentUser.photoUrl,
      rating: userRating, 
      blacklist: userBlacklist
    );

    _currentUser = userProfile;
  }
}