import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Login & Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool success = await authenticateUser(
                  usernameController.text,
                  passwordController.text,
                );

                if (success) {
                  // Navigate to the next screen or perform other actions
                  // after successful login.
                  print('Login Successful');
                } else {
                  // Show error message or handle the unsuccessful login.
                  print('Login Failed');
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> authenticateUser(String username, String password) async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
      },
      version: 1,
    );

    List<Map<String, dynamic>> users = await database.rawQuery(
      'SELECT * FROM users WHERE username = ? AND password = ?',
      [username, password],
    );

    await database.close();

    return users.isNotEmpty;
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool success = await createUser(
                  usernameController.text,
                  passwordController.text,
                );

                if (success) {
                  // Navigate to the login page or perform other actions
                  // after successful signup.
                  Navigator.pop(context); // Go back to the login page
                  print('Signup Successful');
                } else {
                  // Show error message or handle the unsuccessful signup.
                  print('Signup Failed');
                }
              },
              child: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> createUser(String username, String password) async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
      },
      version: 1,
    );

    int result = await database.rawInsert(
      'INSERT INTO users(username, password) VALUES(?, ?)',
      [username, password],
    );

    await database.close();

    return result != -1; // Return true if the insert was successful
  }
}
