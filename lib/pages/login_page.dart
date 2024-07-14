import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/registration_page.dart';
import 'package:flutter_application_1/utils/device_info.dart';
import 'package:flutter_application_1/utils/session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: const Text('Login'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const RegistrationPage()))
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      String userId = userCredential.user?.uid ?? '';

      // Check account status
      bool isStatusValid = await checkAccountStatus(userId);
      if (!isStatusValid) {
        throw Exception('Account is pending or has expired');
      }

      // Get current device info
      Map<String, dynamic> currentDeviceInfo = await getDeviceInfo();

      // Check and save device info
      bool isDeviceValid =
          await checkAndSaveDeviceInfo(userId, currentDeviceInfo);
      if (!isDeviceValid) {
        throw Exception('This device is not authorized to log in');
      }

      // Save session
      await saveSession(userId);
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<bool> checkAccountStatus(String userId) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final String status = userDoc['status'];
      final DateTime registrationDate = userDoc['registrationDate'].toDate();
      final DateTime expiryDate =
          registrationDate.add(const Duration(days: 365));

      if (status == 'approved' && DateTime.now().isBefore(expiryDate)) {
        return true;
      }
    }
    return false;
  }

  Future<bool> checkAndSaveDeviceInfo(
      String userId, Map<String, dynamic> currentDeviceInfo) async {
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('deviceInfo')) {
        // Device info already exists, check against it
        final Map<String, dynamic> savedDeviceInfo = data['deviceInfo'];
        if (savedDeviceInfo['deviceId'] == currentDeviceInfo['deviceId'] &&
            savedDeviceInfo['model'] == currentDeviceInfo['model']) {
          // Device matches
          return true;
        } else {
          // Device does not match
          return false;
        }
      } else {
        // No device info saved yet, save current device info
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'deviceInfo': currentDeviceInfo});
        return true;
      }
    }
    return false;
  }
}
