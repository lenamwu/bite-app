import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAP9IfSjqI38xSs66lQqcJjFIeKdfOveio",
            authDomain: "bite-lla03t.firebaseapp.com",
            projectId: "bite-lla03t",
            storageBucket: "bite-lla03t.firebasestorage.app",
            messagingSenderId: "798690757442",
            appId: "1:798690757442:web:2eed8d2f9c342c26c7d6db"));
  } else {
    await Firebase.initializeApp();
  }
}
