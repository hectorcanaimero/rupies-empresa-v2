import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDwAT5nHdSbu8Kfr4Dut2qS-H_4D4VyGaw",
            authDomain: "rupies-brasil.firebaseapp.com",
            projectId: "rupies-brasil",
            storageBucket: "rupies-brasil.firebasestorage.app",
            messagingSenderId: "68198251813",
            appId: "1:68198251813:web:ede7da8d4fb09757006ecc",
            measurementId: "G-EFET52Q7N7"));
  } else {
    await Firebase.initializeApp();
  }
}
