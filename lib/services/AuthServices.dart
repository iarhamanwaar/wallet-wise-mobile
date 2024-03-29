import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  Future<User?> signUp({
    required String email,
    required String password,
    required String username,
    required String city,
    required String country,
    required String contact,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'password': password,
          'city': city,
          'country': country,
          'contact': contact,
        });

        await _verifyPhoneNumber(contact);
      }

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("phone number verification completed");
        // This callback would get called when verification is done automatically
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) async {
        verificationId2 = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
        print("code time out");
      },
    );
  }

  Future<void> verifyOtp(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      // If you want to link the phone number to the email/password user
      // final User? currentUser = _auth.currentUser;
      // await currentUser?.linkWithCredential(credential);

      // Or simply sign in with the phone number
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      print("Phone number verified and user signed in: ${user?.uid}");
    } catch (e) {
      print("Failed to verify OTP: $e");
    }
  }

  // Send verification email
  Future<void> sendVerificationEmail(User user) async {
    try {
      await user.sendEmailVerification();
      print("Verification email has been sent.");
    } catch (e) {
      print("An error occurred while sending the verification email: $e");
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
