import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';


class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> signInWithEMailAndPassword({
    required String email,
    required String password
  }) async{
    try{
      UserCredential logInUser = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return logInUser.user;

    } catch(e){
      if (e is FirebaseAuthException) {

        // Puoi personalizzare il messaggio di errore in base al codice dell'errore
        String errorMessage = 'Errore durante la registrazione: ';

        switch (e.code) {
          case 'weak-password':
            errorMessage += 'La password è troppo debole.';
            break;
          case 'email-already-in-use':
            errorMessage += 'L\'indirizzo email è già in uso da un altro account.';
            break;
        // Altri casi di errore possono essere gestiti qui
          default:
            errorMessage += 'Si è verificato un errore durante la registrazione.';
        }

        // Puoi rilanciare l'errore con un messaggio personalizzato
        throw FirebaseAuthException(code: e.code, message: errorMessage);
      } else {
        // Se l'errore non è di tipo FirebaseAuthException, rilancialo come è
        throw e;
      }
    }
  }

  Future<User>? createUserWithEMailAndPassword({
    required String email,
    required String password
  }) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      AuthCredential authCredential = await EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      return userCredential.user!;
    } catch(e){
      if (e is FirebaseAuthException) {

        // Puoi personalizzare il messaggio di errore in base al codice dell'errore
        String errorMessage = 'Errore durante la registrazione: ';

        switch (e.code) {
          case 'weak-password':
            errorMessage += 'La password è troppo debole.';
            break;
          case 'email-already-in-use':
            errorMessage += 'L\'indirizzo email è già in uso da un altro account.';
            break;
          case 'invalid-email':
            errorMessage += 'L\'indirizzo email inserito non è valido.';
            break;
        // Altri casi di errore possono essere gestiti qui
          default:
            errorMessage += 'Si è verificato un errore durante la registrazione.';
        }

        // Puoi rilanciare l'errore con un messaggio personalizzato
        throw FirebaseAuthException(code: e.code, message: errorMessage);
      } else {
        // Se l'errore non è di tipo FirebaseAuthException, rilancialo come è
        throw e;
      }
    }
  }


  Future<void> signOut() async{
    try{
      await _firebaseAuth.signOut();
    } catch(e){
      if (e is FirebaseAuthException) {

        // Puoi personalizzare il messaggio di errore in base al codice dell'errore
        String errorMessage = 'Errore durante la registrazione: ';

        switch (e.code) {
          case 'weak-password':
            errorMessage += 'La password è troppo debole.';
            break;
          case 'email-already-in-use':
            errorMessage += 'L\'indirizzo email è già in uso da un altro account.';
            break;
        // Altri casi di errore possono essere gestiti qui
          default:
            errorMessage += 'Si è verificato un errore durante la registrazione.';
        }

        // Puoi rilanciare l'errore con un messaggio personalizzato
        throw FirebaseAuthException(code: e.code, message: errorMessage);
      } else {
        // Se l'errore non è di tipo FirebaseAuthException, rilancialo come è
        throw e;
      }
    }
  }

  Future<void> resetPassword(String email)async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch(e){
      if (e is FirebaseAuthException) {
        throw FirebaseAuthException(code: e.code, message: e.message);
      } else {
        rethrow;
      }
    }
  }

  // Future<User?> signWithGoogle() async {
  //   try {
  //     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       return null;
  //     }
  //
  //     GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
  //
  //     AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
  //     return userCredential.user;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<void> updateEmail(String email) async {
    try {
      await _firebaseAuth.currentUser?.verifyBeforeUpdateEmail(email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      throw e;
    }
  }

  // Future<void> signOutwithGoogle() async {
  //   try{
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     await googleSignIn.signOut();
  //     await FirebaseAuth.instance.signOut();
  //   } catch(e){
  //     print(e);
  //   }
  //
  // }
}


