import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUtils {
  static DatabaseReference getDatabaseRef(String path) {
    return FirebaseDatabase.instance.ref().child(path);
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}