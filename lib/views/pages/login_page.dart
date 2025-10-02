import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productive_360_app/data/dal/db_access.dart' as db_access;
import 'package:productive_360_app/data/notifiers.dart';
import 'package:productive_360_app/models/habit_collection.dart';

import '../widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the card
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32.0), // Padding inside the card
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.monitor_heart_sharp, color: Colors.blue, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please log in to continue.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextField(
                    controller: controllerEmail,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      hintText: 'Email Address',
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextField(
                    controller: controllerPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      hintText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onLoginButtonPressed();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(widget.title, style: TextStyle(fontSize: 16)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(
                            title:
                                widget.title.toLowerCase().contains('register')
                                ? 'Login'
                                : 'Register',
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.title.toLowerCase().contains('register')
                          ? 'Or click to login'
                          : 'Or click to register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLoginButtonPressed() async {
    setState(() {
      errorMessage = '';
    });

    try {
      if (widget.title.toLowerCase().contains('login')) {
        // Firebase login
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: controllerEmail.text.trim(),
          password: controllerPassword.text,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WidgetTree()),
          (route) => false,
        );
      } else if (widget.title.toLowerCase().contains('register')) {
        // Firebase register
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: controllerEmail.text.trim(),
          password: controllerPassword.text,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WidgetTree()),
          (route) => false,
        );
      }

      // try {
      //   final habits = await db_access.loadHabits();
      //   HabitCollection preloadHabits = HabitCollection();
      //   preloadHabits.habits.addAll(habits);
      //   habitCollectionNotifier.value = preloadHabits;
      //   preloadedHabitsNotifier.value = true;
      // } catch (e) {
      //   print("Error preloading habits: $e");
      //   // Optionally show error
      // }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
    } catch (e) {
      setState(() {
        errorMessage =
            'Network error: Please check your internet connection and try again.';
      });
    }
  }
}
